import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/disjunction.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/literal.dart';
import 'package:sqler/src/match_type.dart';

class Where extends Equatable implements Expression {
  final dynamic left;
  final String op;
  final dynamic right;

  const Where(this.left, this.op, this.right);

  factory Where.isNull(Column column) {
    return Where(column, 'IS', Literal.null_);
  }

  factory Where.isNotNull(Column column) {
    return Where(column, 'IS NOT', Literal.null_);
  }

  factory Where.eq(left, right) {
    return right == null ? Where.isNull(left) : Where(left, '=', right);
  }

  factory Where.notEq(left, right) {
    return right == null ? Where.isNotNull(left) : Where(left, '!=', right);
  }

  factory Where.like(
    left,
    right, {
    MatchType type = MatchType.exact,
  }) {
    return Where(left, 'LIKE', _Like(right, type));
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
    return Where(left, 'IN', _In(right));
  }

  factory Where.notIn(left, right) {
    return Where(left, 'NOT IN', _In(right));
  }

  factory Where.between(left, a, b) {
    return Where(left, 'BETWEEN', _Between(a, b));
  }

  factory Where.notBetween(left, a, b) {
    return Where(left, 'NOT BETWEEN', _Between(a, b));
  }

  factory Where.lt(left, right) {
    return Where(left, '<', right);
  }

  factory Where.le(left, right) {
    return Where(left, '<=', right);
  }

  factory Where.gt(left, right) {
    return Where(left, '>', right);
  }

  factory Where.ge(left, right) {
    return Where(left, '>=', right);
  }

  factory Where.not(Where where) {
    return _NotWhere(where.left, where.op, where.right);
  }

  Where not() => _NotWhere(left, op, right);

  Conjunction operator &(Where other) {
    return Conjunction([this, other]);
  }

  Disjunction operator |(Where other) {
    return Disjunction([this, other]);
  }

  String sql({
    bool having = false,
  }) {
    final sb = StringBuffer();

    final left = this.left;
    final right = this.right;

    sb.write(_sql(left, having: having));

    if (op != null) {
      sb.write(' $op ');
    }

    if (right != null) {
      sb.write(_sql(right, having: having));
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [left, op, right];
}

class _NotWhere extends Where {
  const _NotWhere(left, String op, right) : super(left, op, right);

  @override
  String sql({bool having = false}) {
    return 'NOT (${super.sql(having: having)})';
  }
}

class _Like extends Equatable {
  final dynamic value;
  final MatchType type;

  const _Like(this.value, this.type);

  String sql() {
    final start = type == MatchType.end || type == MatchType.anywhere;
    final end = type == MatchType.start || type == MatchType.anywhere;

    final sb = StringBuffer();

    if (value is Column) {
      if (start) {
        sb.write("'%' || ");
      }

      sb.write(value.sql());

      if (end) {
        sb.write(" || '%'");
      }
    } else {
      sb.write("'");

      if (start) {
        sb.write('%');
      }

      if (value is String) {
        sb.write(_escapeString(value));
      } else {
        sb.write(_sql(value));
      }

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

class _In extends Equatable {
  final dynamic a;

  const _In(this.a);

  String sql() {
    return '(${_sql(a)})';
  }

  @override
  List<Object> get props => [a];
}

class _Between extends Equatable {
  final dynamic a;
  final dynamic b;

  const _Between(this.a, this.b);

  String sql() {
    return '${_sql(a)} AND ${_sql(b)}';
  }

  @override
  List<Object> get props => [a, b];
}

String _sql(
  e, {
  bool having = false,
}) {
  if (e == null) {
    return 'NULL';
  } else if (e is Column) {
    return having ? e.nameOrAlias() : e.sql();
  } else if (e is Literal) {
    return e.sql();
  } else if (e is num) {
    return e.toString();
  } else if (e is bool) {
    return e.toString().toUpperCase();
  } else if (e is String) {
    return "'${_escapeString(e)}'";
  } else if (e is List) {
    return _enhancedJoin(e);
  } else if (e is _In || e is _Between || e is _Like) {
    return e.sql();
  } else {
    throw ArgumentError('Unsupported type: ${e.runtimeType}');
  }
}

String _escapeString(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }

  final sb = StringBuffer();

  for (var i = 0; i < text.length; i++) {
    final c = text[i];

    if (c == "'") {
      sb.write("''");
    } else {
      sb.write(c);
    }
  }

  return sb.toString();
}

String _enhancedJoin(List data) {
  final sb = StringBuffer();

  for (var i = 0; i < data.length; i++) {
    if (i > 0) {
      sb.write(',');
    }

    if (data[i] is String) {
      sb.write("'${_escapeString(data[i])}'");
    } else {
      sb.write(data[i]);
    }
  }

  return sb.toString();
}
