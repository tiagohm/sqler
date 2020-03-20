import 'package:sqler/src/expression.dart';

class Literal implements Expression {
  final dynamic _value;

  const Literal(this._value);

  static const null_ = Literal('NULL');
  static const true_ = Literal('TRUE');
  static const false_ = Literal('FALSE');
  static const currentTime = Literal('CURRENT_TIME');
  static const currentDate = Literal('CURRENT_DATE');
  static const currentTimestamp = Literal('CURRENT_TIMESTAMP');

  String sql() => _value?.toString() ?? 'NULL';
}
