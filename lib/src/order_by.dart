import 'package:equatable/equatable.dart';

import 'column.dart';
import 'expression.dart';

enum OrderType { asc, desc }

enum NullOrderType { first, last }

class OrderBy extends Equatable implements Expression {
  final Column column;
  final OrderType order;
  final NullOrderType nullOrder;

  const OrderBy(
    this.column, {
    this.order = OrderType.asc,
    this.nullOrder,
  }) : assert(column != null);

  String sql() {
    final sb = StringBuffer();

    sb.write(column.nameOrAlias());

    if (order != null) {
      sb.write(order == OrderType.desc ? ' DESC' : ' ASC');
    }

    if (nullOrder != null) {
      sb.write(' NULLS ');
      sb.write(nullOrder == NullOrderType.first ? 'FIRST' : 'LAST');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [column, order, nullOrder];
}
