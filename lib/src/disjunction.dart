import 'expression.dart';

class Disjunction implements Expression {
  final List<Expression> parts;

  const Disjunction(this.parts);

  @override
  String toSql() {
    final sb = StringBuffer();

    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        sb.write(' OR ');
      }

      sb.write('(${parts[i].toSql()})');
    }

    return sb.toString();
  }
}
