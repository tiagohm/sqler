import 'package:equatable/equatable.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';

// ignore_for_file: prefer_is_empty
// ignore_for_file: prefer_initializing_formals

class Column extends Equatable implements Expression {
  final dynamic value;
  final Table table;
  final String alias;

  const Column(
    this.value, {
    this.table,
    this.alias,
  });

  static const all = Column('*');

  const Column.name(
    String column, {
    this.table,
    this.alias,
  })  : assert(column != null && column.length > 0),
        value = column;

  const Column.subSelect(
    Query query,
    this.alias,
  )   : assert(query != null),
        assert(alias != null && alias.length > 0),
        value = query,
        table = null;

  @override
  String toSql() {
    final sb = StringBuffer();

    if (table != null) {
      sb.write('${table.alias ?? table.name}.');
    }

    if (value is String) {
      sb.write(value);
    } else if (value is Query) {
      sb.write('(');
      sb.write(value.toSql());
      sb.write(')');
    }

    if (alias != null && alias.isNotEmpty) {
      sb.write(' AS $alias');
    }

    return sb.toString();
  }

  Column copyWith({
    String column,
    Query query,
    Table table,
    String alias,
  }) {
    return Column(
      query ?? column ?? value,
      table: query == null ? table : null,
      alias: alias,
    );
  }

  @override
  List<Object> get props => [value, table, alias];
}
