import 'package:sqler/src/column.dart';
import 'package:sqler/src/conjunction.dart';
import 'package:sqler/src/disjunction.dart';
import 'package:sqler/src/where.dart';
import 'package:test/test.dart';

const score = Column.name('score');
const name = Column.name('name');
const age = Column.name('age');

void main() {
  test('Conjunction', () {
    final where0 = Where.gt(score, 10);
    final where1 = Where.eq(name, 'tiagohm');
    final c = Conjunction([where0, where1]);
    expect(c.toSql(), "(score > 10) AND (name = 'tiagohm')");
  });

  test('Disjunction', () {
    final where0 = Where.gt(score, 10);
    final where1 = Where.eq(name, 'tiagohm');
    final c = Disjunction([where0, where1]);
    expect(c.toSql(), "(score > 10) OR (name = 'tiagohm')");
  });

  test('Conjunction & Disjunction', () {
    final where0 = Where.gt(score, 10);
    final where1 = Where.eq(name, 'tiagohm');
    final where2 = Where.between(age, 10, 26);

    final d = Conjunction([
      where0,
      Disjunction([where1, where2]),
    ]);

    expect(d.toSql(),
        "(score > 10) AND ((name = 'tiagohm') OR (age BETWEEN 10 AND 26))");
  });
}
