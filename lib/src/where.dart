import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/match_type.dart';

class Where extends Equatable implements Expression {
  final WherePart left;
  final String op;
  final WherePart right;

  const Where(this.left, this.op, this.right);

  factory Where.isNull(Column column) {
    return Where(WherePart(column), 'IS', WherePart.null_);
  }

  factory Where.isNotNull(Column column) {
    return Where(WherePart(column), 'IS NOT', WherePart.null_);
  }

  factory Where.eq(left, right) {
    return right == null
        ? Where.isNull(left)
        : Where(
            left is String ? _WrappableWherePart(left) : WherePart(left),
            '=',
            right is String ? _WrappableWherePart(right) : WherePart(right),
          );
  }

  factory Where.notEq(left, right) {
    return right == null
        ? Where.isNotNull(left)
        : Where(
            left is String ? _WrappableWherePart(left) : WherePart(left),
            '!=',
            right is String ? _WrappableWherePart(right) : WherePart(right),
          );
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
    return "'$text'";
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

      sb.write(value);

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
