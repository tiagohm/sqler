import 'package:sqler/src/table.dart';
import 'package:test/test.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/order_by.dart';

const user = Table('user', alias: 'u');
const id = Column('id', alias: 'uid', table: user);

void main() {
  test('Asc', () {
    const orderBy = OrderBy(id, order: OrderType.asc);
    expect(orderBy.sql(), 'uid ASC');
  });

  test('Desc', () {
    const orderBy = OrderBy(id, order: OrderType.desc);
    expect(orderBy.sql(), 'uid DESC');
  });

  test('Nulls First', () {
    const orderBy = OrderBy(id, nullOrder: NullOrderType.first);
    expect(orderBy.sql(), 'uid ASC NULLS FIRST');
  });

  test('Nulls Last', () {
    const orderBy = OrderBy(id, nullOrder: NullOrderType.last);
    expect(orderBy.sql(), 'uid ASC NULLS LAST');
  });
}
