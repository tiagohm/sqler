import 'package:sqler/src/column.dart';
import 'package:sqler/src/table.dart';
import 'package:test/test.dart';

const user = Table('user');
const userWithAlias = Table('user', alias: 'u');

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

  test('SubSelect', () {
    // TODO:
  });
}
