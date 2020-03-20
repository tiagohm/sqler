import 'package:equatable/equatable.dart';
import 'package:sqler/src/disjunction.dart';
import 'package:sqler/src/where.dart';

import 'expression.dart';

class Conjunction extends Equatable implements Expression {
  final List<Expression> parts;

  const Conjunction(this.parts);

  String sql() {
    final sb = StringBuffer();

    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        sb.write(' AND ');
      }

      final dynamic part = parts[i];

      if (part is Conjunction || part is Disjunction || part is Where) {
        sb.write('(${part.sql()})');
      }
    }

    return sb.toString();
  }

  Conjunction operator &(Expression e) {
    return e is Conjunction || e is Disjunction || e is Where
        ? Conjunction([this, e])
        : null;
  }

  Disjunction operator |(Expression e) {
    return e is Conjunction || e is Disjunction || e is Where
        ? Disjunction([this, e])
        : null;
  }

  @override
  List<Object> get props => [parts];
}
