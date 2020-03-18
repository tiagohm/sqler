import 'package:equatable/equatable.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/expression.dart';

class Query extends Equatable implements Expression {
  final String from;
  final List<Column> columns;
  final List where;

  const Query(this.from, this.columns, this.where);

  @override
  String toSql() {
    return null;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
