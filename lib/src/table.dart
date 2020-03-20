import 'package:equatable/equatable.dart';
import 'package:sqler/src/expression.dart';

// ignore_for_file: prefer_is_empty

class Table extends Equatable implements Expression {
  final String schema;
  final String name;
  final String alias;

  const Table(
    this.name, {
    this.schema,
    this.alias,
  }) : assert(name != null && name.length > 0);

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

    if (schema != null && schema.isNotEmpty) {
      sb.write('$schema.');
    }

    sb.write('$name');

    return sb.toString();
  }

  String nameOrAlias() {
    return alias != null && alias.isNotEmpty ? alias : sqlWithoutAlias();
  }

  @override
  List<Object> get props => [name, schema, alias];
}
