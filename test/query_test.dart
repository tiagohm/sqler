import 'package:sqler/src/column.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';
import 'package:test/test.dart';

const user = Table('user', alias: 'u');
const name = Column('name');
const age = Column('age');
const id = Column('id');

void main() {
  test('Fetch All', () {
    const q = Query(user);
    expect(q.toSql(), 'SELECT * FROM user AS u');
  });

  test('Fetch With Where', () {
    final q = Query(user, where: [Where.eq(name, 'tiagohm')]);
    expect(q.toSql(), "SELECT * FROM user AS u WHERE (name = 'tiagohm')");
  });

  test('Fetch With Order By', () {
    final q = Query(
      user,
      where: [Where.eq(name, 'tiagohm')],
      orderBy: const [OrderBy(name)],
    );

    expect(q.toSql(),
        "SELECT * FROM user AS u WHERE (name = 'tiagohm') ORDER BY name ASC");
  });

  test('Fetch With Limit', () {
    final q = Query(
      user,
      where: [Where.eq(name, 'tiagohm')],
      limit: const Limit(10),
    );

    expect(
        q.toSql(), "SELECT * FROM user AS u WHERE (name = 'tiagohm') LIMIT 10");
  });
}
