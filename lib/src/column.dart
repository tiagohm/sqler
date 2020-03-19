import 'package:equatable/equatable.dart';
import 'package:sqler/src/expression.dart';
import 'package:sqler/src/table.dart';

// ignore_for_file: prefer_is_empty

class Column extends Equatable implements Expression {
  final String name;
  final Table table;
  final String alias;

  const Column(
    this.name, {
    this.table,
    this.alias,
  }) : assert(name != null && name.length > 0);

  static const all = Column('*');

  const Column.tableAll(this.table)
      : name = '*',
        alias = null;

  factory Column.aggregate(
    String name,
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return FunctionColumn(
      name,
      column,
      keywords: distinct ? const ['DISTINCT'] : const [],
      alias: alias,
    );
  }

  factory Column.count({
    Column column = all,
    bool distinct = false,
    String alias,
  }) {
    return Column.aggregate('COUNT', column, distinct: distinct, alias: alias);
  }

  factory Column.sum(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return Column.aggregate('SUM', column, distinct: distinct, alias: alias);
  }

  factory Column.avg(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return Column.aggregate('AVG', column, distinct: distinct, alias: alias);
  }

  factory Column.max(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return Column.aggregate('MAX', column, distinct: distinct, alias: alias);
  }

  factory Column.min(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return Column.aggregate('MIN', column, distinct: distinct, alias: alias);
  }

  factory Column.total(
    Column column, {
    bool distinct = false,
    String alias,
  }) {
    return Column.aggregate('TOTAL', column, distinct: distinct, alias: alias);
  }

  String sql() {
    final sb = StringBuffer();

    sb.write(sqlWithoutAlias());

    if (alias != null && alias.isNotEmpty) {
      sb.write(' AS $alias');
    }

    return sb.toString();
  }

  String sqlWithoutAlias() {
    final sb = StringBuffer();

    if (table != null) {
      sb.write('${table.nameOrAlias()}.$name');
    } else {
      sb.write(name);
    }

    return sb.toString();
  }

  String nameOrAlias() {
    if (alias != null && alias.isNotEmpty) {
      return alias;
    } else if (table != null) {
      return '${table.nameOrAlias()}.$name';
    } else {
      return '$name';
    }
  }

  @override
  List<Object> get props => [name, table, alias];
}

class FunctionColumn implements Column {
  @override
  final String name;
  final List<String> keywords;
  final Column column;
  @override
  final String alias;

  const FunctionColumn(
    this.name,
    this.column, {
    this.keywords,
    this.alias,
  });

  @override
  Table get table => column.table;

  @override
  String sql() {
    final sb = StringBuffer();

    sb.write(sqlWithoutAlias());

    if (alias != null && alias.isNotEmpty) {
      sb.write(' AS $alias');
    }

    return sb.toString();
  }

  @override
  String sqlWithoutAlias() {
    final sb = StringBuffer();

    sb.write('$name(');

    if (keywords != null && keywords.isNotEmpty) {
      sb.write(keywords.join(' '));
      sb.write(' ');
    }

    sb.write(column.sqlWithoutAlias());

    sb.write(')');

    return sb.toString();
  }

  @override
  String nameOrAlias() {
    if (alias != null && alias.isNotEmpty) {
      return alias;
    } else {
      return sqlWithoutAlias();
    }
  }

  @override
  List<Object> get props => [name, keywords, column, alias];

  @override
  bool get stringify => false;
}
