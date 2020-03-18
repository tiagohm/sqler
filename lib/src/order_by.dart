import 'package:equatable/equatable.dart';

import 'column.dart';
import 'expression.dart';

enum OrderType { asc, desc }

class OrderBy extends Equatable implements Expression {
  final Column column;
  final OrderType order;
  final bool nullFirst;

  const OrderBy(
    this.column, {
    this.order = OrderType.asc,
    this.nullFirst,
  }) : assert(column != null);

  @override
  String toSql() {
    final sb = StringBuffer();

    sb.write(column.toSql());

    if (order != null) {
      sb.write(order == OrderType.asc ? ' ASC' : ' DESC');
    }

    if (nullFirst != null) {
      sb.write(nullFirst ? ' NULLS FIRST' : ' NULLS LAST');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [column, order, nullFirst];
}
