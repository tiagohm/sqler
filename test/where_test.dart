import 'package:sqler/src/column.dart';
import 'package:sqler/src/match_type.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';
import 'package:test/test.dart';

const user = Table('user');
const id = Column('id');
const userId = Column('id', table: user);

void main() {
  test('Is Null', () {
    final where = Where.isNull(id);
    expect(where.sql(), 'id IS NULL');
  });

  test('Is Not Null', () {
    final where = Where.isNotNull(id);
    expect(where.sql(), 'id IS NOT NULL');
  });

  test('Equal String', () {
    final where = Where.eq(id, 'tiagohm');
    expect(where.sql(), "id = 'tiagohm'");
  });

  test('Equal Boolean', () {
    final where = Where.eq(id, true);
    expect(where.sql(), 'id = true');
  });

  test('Equal Number', () {
    final where = Where.eq(id, 8);
    expect(where.sql(), 'id = 8');
  });

  test('Equal Null', () {
    final where = Where.eq(id, null);
    expect(where.sql(), 'id IS NULL');
  });

  test('Not Equal String', () {
    final where = Where.notEq(id, 'tiagohm');
    expect(where.sql(), "id != 'tiagohm'");
  });

  test('Not Equal Boolean', () {
    final where = Where.notEq(id, true);
    expect(where.sql(), 'id != true');
  });

  test('Not Equal Number', () {
    final where = Where.notEq(id, 8);
    expect(where.sql(), 'id != 8');
  });

  test('Not Equal Null', () {
    final where = Where.notEq(id, null);
    expect(where.sql(), 'id IS NOT NULL');
  });

  test('Column Like Text Exact', () {
    final where = Where.like(id, '123456', type: MatchType.exact);
    expect(where.sql(), "id LIKE '123456'");
  });

  test('Column Like Text Start', () {
    final where = Where.like(id, '123456', type: MatchType.start);
    expect(where.sql(), "id LIKE '123456%'");
  });

  test('Column Like Text End', () {
    final where = Where.like(id, '123456', type: MatchType.end);
    expect(where.sql(), "id LIKE '%123456'");
  });

  test('Column Like Text Anywhere', () {
    final where = Where.like(id, '123456', type: MatchType.anywhere);
    expect(where.sql(), "id LIKE '%123456%'");
  });

  test('Text Like Column Exact', () {
    final where = Where.like('123456', id, type: MatchType.exact);
    expect(where.sql(), "'123456' LIKE id");
  });

  test('Text Like Column Start', () {
    final where = Where.like('123456', id, type: MatchType.start);
    expect(where.sql(), "'123456' LIKE id || '%'");
  });

  test('Text Like Column End', () {
    final where = Where.like('123456', id, type: MatchType.end);
    expect(where.sql(), "'123456' LIKE '%' || id");
  });

  test('Text Like Column Anywhere', () {
    final where = Where.like('123456', id, type: MatchType.anywhere);
    expect(where.sql(), "'123456' LIKE '%' || id || '%'");
  });

  test('Text Like Text Exact', () {
    final where = Where.like('123456', '123456', type: MatchType.exact);
    expect(where.sql(), "'123456' LIKE '123456'");
  });

  test('Text Like Text Start', () {
    final where = Where.like('123456', '123456', type: MatchType.start);
    expect(where.sql(), "'123456' LIKE '123456%'");
  });

  test('Text Like Text End', () {
    final where = Where.like('123456', '123456', type: MatchType.end);
    expect(where.sql(), "'123456' LIKE '%123456'");
  });

  test('Text Like Text Anywhere', () {
    final where = Where.like('123456', '123456', type: MatchType.anywhere);
    expect(where.sql(), "'123456' LIKE '%123456%'");
  });

  test('Column Like Column Exact', () {
    final where = Where.like(id, id, type: MatchType.exact);
    expect(where.sql(), 'id LIKE id');
  });

  test('Column Like Column Start', () {
    final where = Where.like(id, id, type: MatchType.start);
    expect(where.sql(), "id LIKE id || '%'");
  });

  test('Column Like Column End', () {
    final where = Where.like(id, id, type: MatchType.end);
    expect(where.sql(), "id LIKE '%' || id");
  });

  test('Column Like Column Anywhere', () {
    final where = Where.like(id, id, type: MatchType.anywhere);
    expect(where.sql(), "id LIKE '%' || id || '%'");
  });

  test('In Integer List', () {
    final where = Where.in_(id, [1, 2, 3]);
    expect(where.sql(), 'id IN (1,2,3)');
  });

  test('In String List', () {
    final where = Where.in_(id, ['1', '2', '3']);
    expect(where.sql(), "id IN ('1','2','3')");
  });

  test('Not In Integer List', () {
    final where = Where.notIn(id, [1, 2, 3]);
    expect(where.sql(), 'id NOT IN (1,2,3)');
  });

  test('Not In String List', () {
    final where = Where.notIn(id, ['1', '2', '3']);
    expect(where.sql(), "id NOT IN ('1','2','3')");
  });

  test('Between Integer', () {
    final where = Where.between(id, 0, 10);
    expect(where.sql(), 'id BETWEEN 0 AND 10');
  });

  test('Between String', () {
    final where = Where.between(id, 'a', 'z');
    expect(where.sql(), "id BETWEEN 'a' AND 'z'");
  });

  test('Between Column', () {
    final where = Where.between(id, id, id);
    expect(where.sql(), 'id BETWEEN id AND id');
  });

  test('Not Between Integer', () {
    final where = Where.notBetween(id, 0, 10);
    expect(where.sql(), 'id NOT BETWEEN 0 AND 10');
  });

  test('Not Between String', () {
    final where = Where.notBetween(id, 'a', 'z');
    expect(where.sql(), "id NOT BETWEEN 'a' AND 'z'");
  });

  test('Not Between Column', () {
    final where = Where.notBetween(id, id, id);
    expect(where.sql(), 'id NOT BETWEEN id AND id');
  });

  test('Less Than Integer', () {
    final where = Where.lt(id, 0);
    expect(where.sql(), 'id < 0');
  });

  test('Less Than String', () {
    final where = Where.lt(id, 'a');
    expect(where.sql(), "id < 'a'");
  });

  test('Less Or Equal Integer', () {
    final where = Where.le(id, 0);
    expect(where.sql(), 'id <= 0');
  });

  test('Less Or Equal String', () {
    final where = Where.le(id, 'a');
    expect(where.sql(), "id <= 'a'");
  });

  test('Greater Than Integer', () {
    final where = Where.gt(id, 0);
    expect(where.sql(), 'id > 0');
  });

  test('Greater Than String', () {
    final where = Where.gt(id, 'a');
    expect(where.sql(), "id > 'a'");
  });

  test('Greater Or Equal Integer', () {
    final where = Where.ge(id, 0);
    expect(where.sql(), 'id >= 0');
  });

  test('Greater Or Equal String', () {
    final where = Where.ge(id, 'a');
    expect(where.sql(), "id >= 'a'");
  });

  test('Not', () {
    final where = Where.notBetween(id, 0, 10).not();
    expect(where.sql(), 'NOT (id NOT BETWEEN 0 AND 10)');
  });

  test('Column With Table', () {
    final where = Where.eq(userId, 8);
    expect(where.sql(), 'user.id = 8');
  });

  test('Conjunction', () {
    final where = Where.eq(userId, 8) & Where.eq(userId, 9);
    expect(where.sql(), '(user.id = 8) AND (user.id = 9)');
  });

  test('Disjunction', () {
    final where = Where.eq(userId, 8) | Where.eq(userId, 9);
    expect(where.sql(), '(user.id = 8) OR (user.id = 9)');
  });

  test('Conjunction & Disjunction', () {
    final where =
        (Where.ge(userId, 1) & Where.le(userId, 6)) | Where.eq(userId, 9);
    expect(where.sql(), '((user.id >= 1) AND (user.id <= 6)) OR (user.id = 9)');
  });
}
