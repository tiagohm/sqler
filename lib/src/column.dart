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

  factory Column.count({
    Column column = all,
    bool distinct = false,
    String alias,
  }) {
    return FunctionColumn(
      'COUNT',
      column,
      clause: distinct ? 'DISTINCT' : null,
      alias: alias,
    );
  }

  factory Column.avg(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return FunctionColumn(
      'AVG',
      column,
      clause: distinct ? 'DISTINCT' : null,
      alias: alias,
    );
  }

  factory Column.sum(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return FunctionColumn(
      'SUM',
      column,
      clause: distinct ? 'DISTINCT' : null,
      alias: alias,
    );
  }

  factory Column.max(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return FunctionColumn(
      'MAX',
      column,
      clause: distinct ? 'DISTINCT' : null,
      alias: alias,
    );
  }

  factory Column.min(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return FunctionColumn(
      'MIN',
      column,
      clause: distinct ? 'DISTINCT' : null,
      alias: alias,
    );
  }

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
  final String clause;
  final Column column;

  FunctionColumn(
    this.function,
    this.column, {
    this.clause,
    String alias,
  }) : super(column.value, table: column.table, alias: alias);

  @override
  String toSql() {
    final sb = StringBuffer();

    sb.write('$function(');

    if (clause != null && clause.isNotEmpty) {
      sb.write('$clause ');
    }

    sb.write(column.toSql());

    sb.write(')');

    if (alias != null && alias.isNotEmpty) {
      sb.write(' AS $alias');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [function, column, alias];
}
