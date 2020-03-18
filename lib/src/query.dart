import 'package:sqler/src/column.dart';
import 'package:sqler/src/expression.dart';

class Query implements Expression {
  final String from;
  final List<Column> columns;
  final List where;

  Query(this.from, this.columns, this.where);

  @override
  String toSql() {
    return null;
  }
}
