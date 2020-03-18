import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/match_type.dart';

import 'query.dart';

class Where extends Equatable implements Expression {
  final Expression left;
  final String op;
  final Expression right;

  const Where(this.left, this.op, this.right);

  factory Where.isNull(Column column) {
    return Where(WherePart(column), 'IS', WherePart.null_);
  }

  factory Where.isNotNull(Column column) {
    return Where(WherePart(column), 'IS NOT', WherePart.null_);
  }

  factory Where._expr(left, String op, right) {
    return Where(
      left is String ? _WrappableWherePart(left) : WherePart(left),
      op,
      right is String ? _WrappableWherePart(right) : WherePart(right),
    );
  }

  factory Where.eq(left, right) {
    return right == null ? Where.isNull(left) : Where._expr(left, '=', right);
  }

  factory Where.notEq(left, right) {
    return right == null
        ? Where.isNotNull(left)
        : Where._expr(left, '!=', right);
  }

  factory Where.like(
    left,
    right, {
    MatchType type = MatchType.exact,
  }) {
    assert(type != null);

    return Where(
      left is String ? _WrappableWherePart(left) : WherePart(left),
      'LIKE',
      _LikeWherePart(right, type),
    );
  }

  factory Where.likeStart(left, right) {
    return Where.like(left, right, type: MatchType.start);
  }

  factory Where.likeEnd(left, right) {
    return Where.like(left, right, type: MatchType.end);
  }

  factory Where.likeAnywhere(left, right) {
    return Where.like(left, right, type: MatchType.anywhere);
  }

  factory Where.in_(left, right) {
    return Where(
      left is String ? _WrappableWherePart(left) : WherePart(left),
      'IN',
      _InWherePart(right),
    );
  }

  factory Where.notIn(left, right) {
    return Where(
      left is String ? _WrappableWherePart(left) : WherePart(left),
      'NOT IN',
      _InWherePart(right),
    );
  }

  factory Where.between(left, a, b) {
    return Where(
      left is String ? _WrappableWherePart(left) : WherePart(left),
      'BETWEEN',
      _BetweenWherePart(
        a is String ? _WrappableWherePart(a) : WherePart(a),
        b is String ? _WrappableWherePart(b) : WherePart(b),
      ),
    );
  }

  factory Where.notBetween(left, a, b) {
    return Where(
      left is String ? _WrappableWherePart(left) : WherePart(left),
      'NOT BETWEEN',
      _BetweenWherePart(
        a is String ? _WrappableWherePart(a) : WherePart(a),
        b is String ? _WrappableWherePart(b) : WherePart(b),
      ),
    );
  }

  factory Where.lt(left, right) {
    return Where._expr(left, '<', right);
  }

  factory Where.le(left, right) {
    return Where._expr(left, '<=', right);
  }

  factory Where.gt(left, right) {
    return Where._expr(left, '>', right);
  }

  factory Where.ge(left, right) {
    return Where._expr(left, '>=', right);
  }

  factory Where.not(Where where) {
    return _NotWhere(where.left, where.op, where.right);
  }

  Where not() => _NotWhere(left, op, right);

  @override
  String toSql() {
    final sb = StringBuffer();

    if (left != null) {
      sb.write(left.toSql());
    }

    if (op != null) {
      sb.write(' $op ');
    }

    if (right != null) {
      sb.write(right.toSql());
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [left, op, right];
}

class _NotWhere extends Where {
  const _NotWhere(
    Expression left,
    String op,
    Expression right,
  ) : super(left, op, right);

  @override
  String toSql() {
    return 'NOT (${super.toSql()})';
  }
}

class WherePart extends Equatable implements Expression {
  final dynamic value;

  static const null_ = WherePart('NULL');

  const WherePart(this.value);

  @override
  String toSql() {
    return value is Column ? value.toSql() : value.toString();
  }

  @override
  List<Object> get props => [value];
}

class _WrappableWherePart extends WherePart {
  const _WrappableWherePart(String value) : super(value);

  @override
  String toSql() {
    final text = super.toSql();
    return "'$text'"; // TODO: ESCAPE.
  }
}

class _LikeWherePart extends WherePart {
  final MatchType type;

  const _LikeWherePart(value, this.type) : super(value);

  @override
  String toSql() {
    final text = super.toSql();

    final start = type == MatchType.end || type == MatchType.anywhere;
    final end = type == MatchType.start || type == MatchType.anywhere;

    final sb = StringBuffer();

    if (value is Column) {
      if (start) {
        sb.write("'%' || ");
      }

      sb.write(text);

      if (end) {
        sb.write(" || '%'");
      }
    } else {
      sb.write("'");

      if (start) {
        sb.write('%');
      }

      sb.write(value); // TODO: ESCAPE.

      if (end) {
        sb.write('%');
      }

      sb.write("'");
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [value, type];
}

class _InWherePart extends WherePart {
  const _InWherePart(value) : super(value);

  @override
  String toSql() {
    String text;

    if (value is Query) {
      text = value.toSql();
    } else if (value is List) {
      text = _enhancedJoin(value);
    } else if (value is String) {
      text = "'$value'"; // TODO: ESCAPE.
    } else if (value is num || value is bool) {
      text = value.toString();
    } else {
      throw ArgumentError('Unsupported type: ${text?.runtimeType}');
    }

    return '($text)';
  }
}

class _BetweenWherePart extends Equatable implements Expression {
  final Expression a;
  final Expression b;

  const _BetweenWherePart(this.a, this.b);

  @override
  String toSql() {
    return '${a.toSql()} AND ${b.toSql()}';
  }

  @override
  List<Object> get props => [a, b];
}

String _enhancedJoin(List data) {
  final sb = StringBuffer();

  for (var i = 0; i < data.length; i++) {
    if (i > 0) {
      sb.write(',');
    }

    if (data[i] is String) {
      sb.write("'${data[i]}'"); // TODO: ESCAPE.
    } else {
      sb.write(data[i]);
    }
  }

  return sb.toString();
}
