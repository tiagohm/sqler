import 'package:equatable/equatable.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/where.dart';

import 'expression.dart';

class Disjunction extends Equatable implements Expression {
  final List<Where> parts;

  const Disjunction(this.parts);

  String sql() {
    final sb = StringBuffer();

    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        sb.write(' OR ');
      }

      final dynamic part = parts[i];

      if (part is Conjunction || part is Disjunction || part is Where) {
        sb.write('(${part.sql()})');
      }
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [parts];
}
