import 'package:equatable/equatable.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';

class Join extends Equatable implements Expression {
  final String op;
  final dynamic table;
  final List<Where> where;
  final String alias;

  const Join(
    this.op,
    this.table,
    this.where, {
    this.alias,
  });

  const Join.left(
    this.table,
    this.where, {
    this.alias,
  }) : op = 'LEFT';

  const Join.right(
    this.table,
    this.where, {
    this.alias,
  }) : op = 'RIGHT';

  const Join.inner(
    this.table,
    this.where, {
    this.alias,
  }) : op = 'INNER';

  const Join.full(
    this.table,
    this.where, {
    this.alias,
  }) : op = 'FULL';

  const Join.cross(
    this.table,
    this.where, {
    this.alias,
  }) : op = 'CROSS';

  String sql() {
    final sb = StringBuffer();
    final table = this.table;
    final where = this.where;

    if (op != null) {
      sb.write(op);
    }

    sb.write(' JOIN ');

    if (table is Table) {
      sb.write(table.sql());
    } else if (table is Query) {
      sb.write('(${table.sql()})');

      if (alias != null && alias.isNotEmpty) {
        sb.write(' AS $alias');
      }
    } else {
      throw ArgumentError('Unsupported type: ${table.runtimeType}');
    }

    if (where != null && where.isNotEmpty) {
      final c = Conjunction(where);
      sb.write(' ON ${c.sql()}');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [op, table, where];
}
