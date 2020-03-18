import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/expression.dart';

class Where extends Equatable implements Expression {
  final WherePart left;
  final String op;
  final WherePart right;

  const Where._(this.left, this.op, this.right);

  factory Where.isNull(Column column) {
    return Where._(WherePart(column), 'IS', WherePart.null_);
  }

  factory Where.isNotNull(Column column) {
    return Where._(WherePart(column), 'IS NOT', WherePart.null_);
  }

  factory Where.eq(
    left,
    right,
  ) {
    return right == null
        ? Where.isNull(left)
        : Where._(WherePart(left), '=',
            right is String ? WherePart.wrap(right) : WherePart(right));
  }

  @override
  String toSql() {
    return null;
  }

  @override
  List<Object> get props => [left, op, right];
}

class WherePart extends Equatable implements Expression {
  final dynamic value;
  final bool wrappable;

  static const null_ = WherePart('NULL');

  const WherePart(
    this.value, {
    this.wrappable = false,
  });

  const WherePart.wrap(this.value) : wrappable = true;

  @override
  String toSql() {
    final text = value is Column ? value.toSql() : value.toString();
    return wrappable && value is String ? "'$text'" : text;
  }

  @override
  List<Object> get props => [value, wrappable];
}
