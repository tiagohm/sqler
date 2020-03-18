import 'package:sqler/src/expression.dart';
import 'package:sqler/src/query.dart';

// ignore_for_file: prefer_is_empty
// ignore_for_file: prefer_initializing_formals

class Column implements Expression {
  final dynamic value;
  final String table;
  final String alias;

  const Column._(
    this.value, {
    this.table,
    this.alias,
  });

  static const all = Column._('*');

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

    if (table != null && table.isNotEmpty) {
      sb.write('$table.');
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
    String table,
    String alias,
  }) {
    return Column._(
      query ?? column ?? value,
      table: query == null ? table : null,
      alias: alias,
    );
  }
}
