import 'package:sqler/src/column.dart';
import 'package:sqler/src/join.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';
import 'package:test/test.dart';

const user = Table('user', alias: 'u');
const address = Table('address', alias: 'addr');
const name = Column('name');
const age = Column('age');
const id = Column('id');
const userAddress = Column('address', table: user);
const addrId = Column('id', table: address);

void main() {
  test('Simple', () {
    const q = Query(user);
    expect(q.sql(), 'SELECT * FROM user AS u');
  });

  test('Join', () {
    final where0 = Where.eq(userAddress, addrId);
    final join = Join.left(address, [where0]);
    final q = Query(user, join: [join], where: [Where.eq(name, 'tiagohm')]);
    expect(q.sql(), "SELECT * FROM user AS u LEFT JOIN address AS addr ON (u.address = addr.id) WHERE (name = 'tiagohm')");
  });

  test('Where', () {
    final q = Query(user, where: [Where.eq(name, 'tiagohm')]);
    expect(q.sql(), "SELECT * FROM user AS u WHERE (name = 'tiagohm')");
  });

  test('Having', () {
    final count = Column.count(alias: 'c');
    final q = Query(user, having: Where.eq(count, 1));
    expect(q.sql(), 'SELECT * FROM user AS u HAVING c = 1');
  });

  test('Order By', () {
    final q = Query(
      user,
      where: [Where.eq(name, 'tiagohm')],
      orderBy: const [OrderBy(name)],
    );

    expect(q.sql(),
        "SELECT * FROM user AS u WHERE (name = 'tiagohm') ORDER BY name ASC");
  });

  test('Limit', () {
    final q = Query(
      user,
      where: [Where.eq(name, 'tiagohm')],
      limit: const Limit(10),
    );

    expect(
        q.sql(), "SELECT * FROM user AS u WHERE (name = 'tiagohm') LIMIT 10");
  });
}
