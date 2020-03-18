import 'package:sqler/src/column.dart';
import 'package:test/test.dart';

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
    const column = Column.name('id', table: 'user');
    expect(column.toSql(), 'user.id');
  });

  test('Name With Table And Alias', () {
    const column = Column.name('id', table: 'user', alias: 'uid');
    expect(column.toSql(), 'user.id AS uid');
  });

  test('SubSelect', () {
    // TODO:
  });
}
