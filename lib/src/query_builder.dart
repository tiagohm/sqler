import 'package:sqler/src/column.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/disjunction.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/join.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';

class QueryBuilder {
  Table _from;
  final List<Column> _columns = [];
  final List<Join> _join = [];
  final List<Expression> _where = [];
  Where _having;
  final List<OrderBy> _orderBy = [];
  Limit _limit;

  void from(Table from) {
    _from = from;
  }

  void column(Column column) {
    _columns.add(column);
  }

  void leftJoin(
    table, {
    List<Where> on,
    String alias,
  }) {
    _join.add(Join.left(table, on: on, alias: alias));
  }

  void rightJoin(
    table, {
    List<Where> on,
    String alias,
  }) {
    _join.add(Join.right(table, on: on, alias: alias));
  }

  void innerJoin(
    table, {
    List<Where> on,
    String alias,
  }) {
    _join.add(Join.inner(table, on: on, alias: alias));
  }

  void fullJoin(
    table, {
    List<Where> on,
    String alias,
  }) {
    _join.add(Join.full(table, on: on, alias: alias));
  }

  void crossJoin(
    table, {
    List<Where> on,
    String alias,
  }) {
    _join.add(Join.cross(table, on: on, alias: alias));
  }

  void where(where) {
    if (where is Disjunction || where is Conjunction || where is Where) {
      _where.add(where);
    } else {
      throw ArgumentError('Unsupported type: ${where.runtimeType}');
    }
  }

  void having(Where having) {
    _having = having;
  }

  void orderBy(OrderBy orderBy) {
    _orderBy.add(orderBy);
  }

  void limit(Limit limit) {
    _limit = limit;
  }

  Query toQuery() {
    return Query(
      _from,
      columns: _columns,
      having: _having,
      join: _join,
      limit: _limit,
      orderBy: _orderBy,
      where: _where,
    );
  }

  String sql() {
    return toQuery().sql();
  }
}
