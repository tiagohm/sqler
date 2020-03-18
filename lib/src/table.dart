import 'package:equatable/equatable.dart';
import 'package:sqler/src/expression.dart';

// ignore_for_file: prefer_is_empty

class Table extends Equatable implements Expression {
  final String name;
  final String alias;

  const Table(
    this.name, {
    this.alias,
  }) : assert(name != null && name.length > 0);

  @override
  String toSql() {
    final sb = StringBuffer();

    sb.write('$name');

    if (alias != null && alias.isNotEmpty) {
      sb.write(' AS $alias');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [name, alias];
}
