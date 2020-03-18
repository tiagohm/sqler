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

  factory Column.count({String alias}) =>
      FunctionColumn('COUNT', all, alias: alias);

  factory Column.avg(Column column, {String alias}) =>
      FunctionColumn('AVG', column, alias: alias);

  factory Column.sum(Column column, {String alias}) =>
      FunctionColumn('SUM', column, alias: alias);

  @override
  String toSql() {
    final sb = StringBuffer();

    if (table != null) {
      sb.write('${table.alias ?? table.name}.$value');
    } else if (value is String) {
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

  @override
  List<Object> get props => [value, table, alias];
}

class FunctionColumn extends Column {
  final String function;
  final Column column;

  FunctionColumn(
    this.function,
    this.column, {
    String alias,
  }) : super(column.value, table: column.table, alias: alias);

  @override
  String toSql() {
    final sb = StringBuffer();

    sb.write('$function(${column.toSql()})');

    if (alias != null && alias.isNotEmpty) {
      sb.write(' AS $alias');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [function, column, alias];
}
