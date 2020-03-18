import 'package:sqler/src/column.dart';
import 'package:sqler/src/table.dart';
import 'package:test/test.dart';

const user = Table('user');
const userWithAlias = Table('user', alias: 'u');
const age = Column.name('age');

void main() {
  test('Name', () {
    const column = Column.name('usr_id');
    expect(column.toSql(), 'usr_id');
  });

  test('Name With Alias', () {
    const column = Column.name('user_id', alias: 'id');
    expect(column.toSql(), 'user_id AS id');
  });

  test('Name With Table', () {
    const column = Column.name('id', table: user);
    expect(column.toSql(), 'user.id');
  });

  test('Name With Table And Alias', () {
    const column = Column.name('id', table: user, alias: 'uid');
    expect(column.toSql(), 'user.id AS uid');
  });

  test('Name With Table Alias And Alias', () {
    const column = Column.name('id', table: userWithAlias, alias: 'uid');
    expect(column.toSql(), 'u.id AS uid');
  });

  test('Count', () {
    final column = Column.count(alias: 'c');
    expect(column.toSql(), 'COUNT(*) AS c');
  });

  test('Avg', () {
    final column = Column.avg(age, alias: 'age');
    expect(column.toSql(), 'AVG(age) AS age');
  });

  test('Avg With Distinct', () {
    final column = Column.avg(age, distinct: true, alias: 'age');
    expect(column.toSql(), 'AVG(DISTINCT age) AS age');
  });

  test('Sum', () {
    final column = Column.sum(age, alias: 'age');
    expect(column.toSql(), 'SUM(age) AS age');
  });

  test('Min', () {
    final column = Column.min(age, alias: 'age');
    expect(column.toSql(), 'MIN(age) AS age');
  });

  test('Max', () {
    final column = Column.max(age, alias: 'age');
    expect(column.toSql(), 'MAX(age) AS age');
  });

  test('SubSelect', () {
    // TODO:
  });
}
