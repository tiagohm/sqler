import 'package:sqler/src/column.dart';
import 'package:sqler/src/join.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';
import 'package:test/test.dart';

const user = Table('user');
const address = Table('address', alias: 'addr');
const userId = Column('id', table: user);
const userAddress = Column('address', table: user);
const addrId = Column('id', table: address);

void main() {
  test('Left', () {
    final where0 = Where.eq(userAddress, addrId);
    final join = Join.left(address, on: [where0]);
    expect(join.sql(), 'LEFT JOIN address AS addr ON (user.address = addr.id)');
  });

  test('Right', () {
    final where0 = Where.eq(userAddress, addrId);
    final join = Join.right(address, on: [where0]);
    expect(
        join.sql(), 'RIGHT JOIN address AS addr ON (user.address = addr.id)');
  });

  test('Inner', () {
    final where0 = Where.eq(userAddress, addrId);
    final join = Join.inner(address, on: [where0]);
    expect(
        join.sql(), 'INNER JOIN address AS addr ON (user.address = addr.id)');
  });

  test('Full', () {
    final where0 = Where.eq(userAddress, addrId);
    final join = Join.full(address, on: [where0]);
    expect(join.sql(), 'FULL JOIN address AS addr ON (user.address = addr.id)');
  });

  test('Cross', () {
    final where0 = Where.eq(userAddress, addrId);
    final join = Join.cross(address, on: [where0]);
    expect(
        join.sql(), 'CROSS JOIN address AS addr ON (user.address = addr.id)');
  });

  test('With Query', () {
    final sq = Query(address, where: [Where.gt(addrId, 7)]);
    final where0 = Where.eq(userAddress, const Column('p.id'));
    final join = Join.left(sq, on: [where0], alias: 'p');
    expect(join.sql(),
        'LEFT JOIN (SELECT * FROM address AS addr WHERE (addr.id > 7)) AS p ON (user.address = p.id)');
  });
}
