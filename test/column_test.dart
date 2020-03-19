import 'package:sqler/src/column.dart';
import 'package:sqler/src/table.dart';
import 'package:test/test.dart';

const user = Table('user');
const userWithAlias = Table('user', alias: 'u');
const age = Column('age');

void main() {
  test('Column', () {
    const column = Column('usr_id');
    expect(column.sql(), 'usr_id');
    expect(column.sqlWithoutAlias(), 'usr_id');
    expect(column.nameOrAlias(), 'usr_id');
  });

  test('Column With Alias', () {
    const column = Column('user_id', alias: 'uid');
    expect(column.sql(), 'user_id AS uid');
    expect(column.sqlWithoutAlias(), 'user_id');
    expect(column.nameOrAlias(), 'uid');
  });

  test('Column With Table', () {
    const column = Column('id', table: user);
    expect(column.sql(), 'user.id');
    expect(column.sqlWithoutAlias(), 'user.id');
    expect(column.nameOrAlias(), 'user.id');
  });

  test('Column With Table And Alias', () {
    const column = Column('id', table: user, alias: 'uid');
    expect(column.sql(), 'user.id AS uid');
    expect(column.sqlWithoutAlias(), 'user.id');
    expect(column.nameOrAlias(), 'uid');
  });

  test('Column With Table Alias', () {
    const column = Column('id', table: userWithAlias);
    expect(column.sql(), 'u.id');
    expect(column.sqlWithoutAlias(), 'u.id');
    expect(column.nameOrAlias(), 'u.id');
  });

  test('Column With Table Alias And Alias', () {
    const column = Column('id', table: userWithAlias, alias: 'uid');
    expect(column.sql(), 'u.id AS uid');
    expect(column.sqlWithoutAlias(), 'u.id');
    expect(column.nameOrAlias(), 'uid');
  });

  test('Count', () {
    final column = Column.count(alias: 'c');
    expect(column.sql(), 'COUNT(*) AS c');
    expect(column.sqlWithoutAlias(), 'COUNT(*)');
    expect(column.nameOrAlias(), 'c');
  });

  test('Count With Column', () {
    final column = Column.count(column: age, alias: 'c');
    expect(column.sql(), 'COUNT(age) AS c');
    expect(column.sqlWithoutAlias(), 'COUNT(age)');
    expect(column.nameOrAlias(), 'c');
  });

  test('Avg', () {
    final column = Column.avg(age, alias: 'age');
    expect(column.sql(), 'AVG(age) AS age');
    expect(column.sqlWithoutAlias(), 'AVG(age)');
    expect(column.nameOrAlias(), 'age');
  });

  test('Avg With Distinct', () {
    final column = Column.avg(age, distinct: true, alias: 'age');
    expect(column.sql(), 'AVG(DISTINCT age) AS age');
    expect(column.sqlWithoutAlias(), 'AVG(DISTINCT age)');
    expect(column.nameOrAlias(), 'age');
  });

  test('Sum', () {
    final column = Column.sum(age, alias: 'age');
    expect(column.sql(), 'SUM(age) AS age');
    expect(column.sqlWithoutAlias(), 'SUM(age)');
    expect(column.nameOrAlias(), 'age');
  });

  test('Min', () {
    final column = Column.min(age, alias: 'age');
    expect(column.sql(), 'MIN(age) AS age');
    expect(column.sqlWithoutAlias(), 'MIN(age)');
    expect(column.nameOrAlias(), 'age');
  });

  test('Max', () {
    final column = Column.max(age, alias: 'age');
    expect(column.sql(), 'MAX(age) AS age');
    expect(column.sqlWithoutAlias(), 'MAX(age)');
    expect(column.nameOrAlias(), 'age');
  });

  test('SubSelect', () {
    // TODO:
  });
}
