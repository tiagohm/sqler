import 'package:sqler/src/column.dart';
import 'package:sqler/src/join.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';

export 'package:sqler/src/order_by.dart' show NullOrderType;
export 'package:sqler/src/query.dart';
export 'package:sqler/src/query_builder.dart';

// Table.

Table table(
  String name, {
  String schema,
  String alias,
}) =>
    Table(name, schema: schema, alias: alias);

// Column.

Column col(
  String name, {
  Table table,
  String alias,
}) =>
    Column(name, table: table, alias: alias);

Column tableAll(Table table) => Column.tableAll(table);

const all = Column.all;

Column count({
  Column column = all,
  bool distinct = false,
  String alias,
}) =>
    Column.count(column: column, distinct: distinct, alias: alias);

Column sum(
  Column column, {
  bool distinct = false,
  String alias,
}) =>
    Column.sum(column, distinct: distinct, alias: alias);

Column avg(
  Column column, {
  bool distinct = false,
  String alias,
}) =>
    Column.avg(column, distinct: distinct, alias: alias);

Column max(
  Column column, {
  bool distinct = false,
  String alias,
}) =>
    Column.max(column, distinct: distinct, alias: alias);

Column min(
  Column column, {
  bool distinct = false,
  String alias,
}) =>
    Column.min(column, distinct: distinct, alias: alias);

Column total(
  Column column, {
  bool distinct = false,
  String alias,
}) =>
    Column.total(column, distinct: distinct, alias: alias);

// Where.

Where isNull(left) => Where.isNull(left);

Where isNotNull(left) => Where.isNotNull(left);

Where eq(left, right) => Where.eq(left, right);

Where ne(left, right) => Where.notEq(left, right);

Where likeStart(left, right) => Where.likeStart(left, right);

Where likeEnd(left, right) => Where.likeEnd(left, right);

Where likeAnywhere(left, right) => Where.likeAnywhere(left, right);

Where like(left, right) => Where.like(left, right);

Where in_(left, right) => Where.in_(left, right);

Where notIn(left, right) => Where.notIn(left, right);

Where between(left, a, b) => Where.between(left, a, b);

Where notBetween(left, a, b) => Where.notBetween(left, a, b);

Where lt(left, right) => Where.lt(left, right);

Where le(left, right) => Where.le(left, right);

Where gt(left, right) => Where.gt(left, right);

Where ge(left, right) => Where.ge(left, right);

Where not(Where where) => Where.not(where);

// Order By.

OrderBy asc(
  Column column, {
  NullOrderType nullOrder,
}) =>
    OrderBy(column, order: OrderType.asc, nullOrder: nullOrder);

OrderBy desc(
  Column column, {
  NullOrderType nullOrder,
}) =>
    OrderBy(column, order: OrderType.desc, nullOrder: nullOrder);

// Limit.

Limit offset(int offset) => Limit.offset(offset);

Limit paginate(
  int page, {
  int perPage = 10,
}) =>
    Limit.paginate(page, perPage: 10);

Limit limit(
  int limit, {
  int offset,
}) =>
    Limit(limit, offset: offset);

// Join.

Join leftJoin(
  table, {
  List<Where> on,
  String alias,
}) =>
    Join.left(table, on: on, alias: alias);

Join rightJoin(
  table, {
  List<Where> on,
  String alias,
}) =>
    Join.right(table, on: on, alias: alias);

Join innerJoin(
  table, {
  List<Where> on,
  String alias,
}) =>
    Join.inner(table, on: on, alias: alias);

Join fullJoin(
  table, {
  List<Where> on,
  String alias,
}) =>
    Join.full(table, on: on, alias: alias);

Join crossJoin(
  table, {
  List<Where> on,
  String alias,
}) =>
    Join.cross(table, on: on, alias: alias);
