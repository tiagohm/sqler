import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/join.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';

class Query extends Equatable implements Expression {
  final Table from;
  final List<Column> columns;
  final List<Join> join;
  final List<Expression> where;
  final Where having;
  final List<OrderBy> orderBy;
  final Limit limit;

  const Query(
    this.from, {
    this.columns = const [],
    this.join = const [],
    this.where = const [],
    this.having,
    this.orderBy = const [],
    this.limit,
  });

  String sql() {
    final sb = StringBuffer();

    sb.write('SELECT ');

    if (columns == null || columns.isEmpty) {
      sb.write('*');
    } else {
      for (var i = 0; i < columns.length; i++) {
        if (i > 0) {
          sb.write(', ');
        }

        sb.write(columns[i].sql());
      }
    }

    sb.write(' FROM ${from.sql()}');

    if (join != null && join.isNotEmpty) {
      sb.write(' ');

      for (var i = 0; i < join.length; i++) {
        if (i > 0) {
          sb.write(' ');
        }

        sb.write(join[i].sql());
      }
    }

    if (where != null && where.isNotEmpty) {
      final c = Conjunction(where);
      sb.write(' WHERE ${c.sql()}');
    }

    if (having != null) {
      sb.write(' HAVING ${having.sql(having: true)}');
    }

    if (orderBy != null && orderBy.isNotEmpty) {
      sb.write(' ORDER BY ');

      for (var i = 0; i < orderBy.length; i++) {
        if (i > 0) {
          sb.write(',');
        }

        sb.write(orderBy[i].sql());
      }
    }

    if (limit != null) {
      sb.write(' ');
      sb.write(limit.sql());
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [from, columns, where, orderBy, limit];
}
