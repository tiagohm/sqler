import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';

class Query extends Equatable implements Expression {
  final Table from;
  final List<Column> columns;
  final List<Where> where;
  final Where having;
  final List<OrderBy> orderBy;
  final Limit limit;

  const Query(
    this.from, {
    this.columns = const [],
    this.where = const [],
    this.having,
    this.orderBy = const [],
    this.limit,
  });

  @override
  String toSql() {
    final sb = StringBuffer();

    sb.write('SELECT ');

    if (columns == null || columns.isEmpty) {
      sb.write('*');
    } else {
      sb.write(columns.join(','));
    }

    sb.write(' FROM ${from.toSql()}');

    if (where != null && where.isNotEmpty) {
      final c = Conjunction(where);
      sb.write(' WHERE ${c.toSql()}');
    }

    if (having != null) {
      sb.write(' HAVING ${having.toSql()}');
    }

    if (orderBy != null && orderBy.isNotEmpty) {
      sb.write(' ORDER BY ');

      for (var i = 0; i < orderBy.length; i++) {
        if (i > 0) {
          sb.write(',');
        }

        sb.write(orderBy[i].toSql());
      }
    }

    if (limit != null) {
      sb.write(' ');
      sb.write(limit.toSql());
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [from, columns, where, orderBy, limit];
}
