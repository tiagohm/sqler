import 'package:equatable/equatable.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';

class Join extends Equatable implements Expression {
  final String op;
  final dynamic table;
  final List<Where> on;
  final String alias;

  const Join(
    this.op,
    this.table, {
    this.on,
    this.alias,
  });

  const Join.left(
    this.table, {
    this.on,
    this.alias,
  }) : op = 'LEFT';

  const Join.right(
    this.table, {
    this.on,
    this.alias,
  }) : op = 'RIGHT';

  const Join.inner(
    this.table, {
    this.on,
    this.alias,
  }) : op = 'INNER';

  const Join.full(
    this.table, {
    this.on,
    this.alias,
  }) : op = 'FULL';

  const Join.cross(
    this.table, {
    this.on,
    this.alias,
  }) : op = 'CROSS';

  String sql() {
    final sb = StringBuffer();
    final table = this.table;
    final on = this.on;

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

    if (on != null && on.isNotEmpty) {
      final c = Conjunction(on);
      sb.write(' ON ${c.sql()}');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [op, table, on];
}
