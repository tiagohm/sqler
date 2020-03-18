import 'package:test/test.dart';
import 'package:sqler/src/column.dart';
import 'package:sqler/src/order_by.dart';

const id = Column.name('id');

void main() {
  test('Asc', () {
    const orderBy = OrderBy(id, order: OrderType.asc);
    expect(orderBy.toSql(), 'id ASC');
  });

  test('Desc', () {
    const orderBy = OrderBy(id, order: OrderType.desc);
    expect(orderBy.toSql(), 'id DESC');
  });

  test('Nulls First', () {
    const orderBy = OrderBy(id, nullFirst: true);
    expect(orderBy.toSql(), 'id ASC NULLS FIRST');
  });

  test('Nulls Last', () {
    const orderBy = OrderBy(id, nullFirst: false);
    expect(orderBy.toSql(), 'id ASC NULLS LAST');
  });
}
