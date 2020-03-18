import 'package:sqler/src/match_type.dart';
import 'package:test/test.dart';

import 'package:sqler/src/column.dart';
import 'package:sqler/src/where.dart';

const id = Column.name('id');

void main() {
  test('Is Null', () {
    final where = Where.isNull(id);
    expect(where.toSql(), 'id IS NULL');
  });

  test('Is Not Null', () {
    final where = Where.isNotNull(id);
    expect(where.toSql(), 'id IS NOT NULL');
  });

  test('Equal String', () {
    final where = Where.eq(id, 'tiagohm');
    expect(where.toSql(), "id = 'tiagohm'");
  });

  test('Equal Boolean', () {
    final where = Where.eq(id, true);
    expect(where.toSql(), 'id = true');
  });

  test('Equal Number', () {
    final where = Where.eq(id, 8);
    expect(where.toSql(), 'id = 8');
  });

  test('Equal Null', () {
    final where = Where.eq(id, null);
    expect(where.toSql(), 'id IS NULL');
  });

  test('Not Equal String', () {
    final where = Where.notEq(id, 'tiagohm');
    expect(where.toSql(), "id != 'tiagohm'");
  });

  test('Not Equal Boolean', () {
    final where = Where.notEq(id, true);
    expect(where.toSql(), 'id != true');
  });

  test('Not Equal Number', () {
    final where = Where.notEq(id, 8);
    expect(where.toSql(), 'id != 8');
  });

  test('Not Equal Null', () {
    final where = Where.notEq(id, null);
    expect(where.toSql(), 'id IS NOT NULL');
  });

  test('Column Like Text Exact', () {
    final where = Where.like(id, '123456', type: MatchType.exact);
    expect(where.toSql(), "id LIKE '123456'");
  });

  test('Column Like Text Start', () {
    final where = Where.like(id, '123456', type: MatchType.start);
    expect(where.toSql(), "id LIKE '123456%'");
  });

  test('Column Like Text End', () {
    final where = Where.like(id, '123456', type: MatchType.end);
    expect(where.toSql(), "id LIKE '%123456'");
  });

  test('Column Like Text Anywhere', () {
    final where = Where.like(id, '123456', type: MatchType.anywhere);
    expect(where.toSql(), "id LIKE '%123456%'");
  });

  test('Text Like Column Exact', () {
    final where = Where.like('123456', id, type: MatchType.exact);
    expect(where.toSql(), "'123456' LIKE id");
  });

  test('Text Like Column Start', () {
    final where = Where.like('123456', id, type: MatchType.start);
    expect(where.toSql(), "'123456' LIKE id || '%'");
  });

  test('Text Like Column End', () {
    final where = Where.like('123456', id, type: MatchType.end);
    expect(where.toSql(), "'123456' LIKE '%' || id");
  });

  test('Text Like Column Anywhere', () {
    final where = Where.like('123456', id, type: MatchType.anywhere);
    expect(where.toSql(), "'123456' LIKE '%' || id || '%'");
  });

  test('Text Like Text Exact', () {
    final where = Where.like('123456', '123456', type: MatchType.exact);
    expect(where.toSql(), "'123456' LIKE '123456'");
  });

  test('Text Like Text Start', () {
    final where = Where.like('123456', '123456', type: MatchType.start);
    expect(where.toSql(), "'123456' LIKE '123456%'");
  });

  test('Text Like Text End', () {
    final where = Where.like('123456', '123456', type: MatchType.end);
    expect(where.toSql(), "'123456' LIKE '%123456'");
  });

  test('Text Like Text Anywhere', () {
    final where = Where.like('123456', '123456', type: MatchType.anywhere);
    expect(where.toSql(), "'123456' LIKE '%123456%'");
  });

  test('Column Like Column Exact', () {
    final where = Where.like(id, id, type: MatchType.exact);
    expect(where.toSql(), 'id LIKE id');
  });

  test('Column Like Column Start', () {
    final where = Where.like(id, id, type: MatchType.start);
    expect(where.toSql(), "id LIKE id || '%'");
  });

  test('Column Like Column End', () {
    final where = Where.like(id, id, type: MatchType.end);
    expect(where.toSql(), "id LIKE '%' || id");
  });

  test('Column Like Column Anywhere', () {
    final where = Where.like(id, id, type: MatchType.anywhere);
    expect(where.toSql(), "id LIKE '%' || id || '%'");
  });

  test('In Integer List', () {
    final where = Where.in_(id, [1, 2, 3]);
    expect(where.toSql(), 'id IN (1,2,3)');
  });

  test('In String List', () {
    final where = Where.in_(id, ['1', '2', '3']);
    expect(where.toSql(), "id IN ('1','2','3')");
  });

  test('Not In Integer List', () {
    final where = Where.notIn(id, [1, 2, 3]);
    expect(where.toSql(), 'id NOT IN (1,2,3)');
  });

  test('Not In String List', () {
    final where = Where.notIn(id, ['1', '2', '3']);
    expect(where.toSql(), "id NOT IN ('1','2','3')");
  });

  test('Between Integer', () {
    final where = Where.between(id, 0, 10);
    expect(where.toSql(), 'id BETWEEN 0 AND 10');
  });

  test('Between String', () {
    final where = Where.between(id, 'a', 'z');
    expect(where.toSql(), "id BETWEEN 'a' AND 'z'");
  });

  test('Not Between Integer', () {
    final where = Where.notBetween(id, 0, 10);
    expect(where.toSql(), 'id NOT BETWEEN 0 AND 10');
  });

  test('Not Between String', () {
    final where = Where.notBetween(id, 'a', 'z');
    expect(where.toSql(), "id NOT BETWEEN 'a' AND 'z'");
  });
}
