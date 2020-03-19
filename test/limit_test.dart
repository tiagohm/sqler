import 'package:test/test.dart';
import 'package:sqler/src/limit.dart';

void main() {
  test('Limit & Offset', () {
    const limit = Limit(25, offset: 0);
    expect(limit.sql(), 'LIMIT 25 OFFSET 0');
  });

  test('Paginate', () {
    const limit = Limit.paginate(5, perPage: 10);
    expect(limit.sql(), 'LIMIT 10 OFFSET 40');
  });

  test('Offset', () {
    const limit = Limit.offset(6);
    expect(limit.sql(), 'LIMIT -1 OFFSET 6');
  });
}
