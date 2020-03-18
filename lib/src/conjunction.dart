import 'package:equatable/equatable.dart';

import 'expression.dart';

class Conjunction extends Equatable implements Expression {
  final List<Expression> parts;

  const Conjunction(this.parts);

  @override
  String toSql() {
    final sb = StringBuffer();

    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        sb.write(' AND ');
      }

      sb.write('(${parts[i].toSql()})');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [parts];
}
