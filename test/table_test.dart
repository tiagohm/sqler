import 'package:sqler/src/table.dart';
import 'package:test/test.dart';

void main() {
  test('Table Name', () {
    const table = Table('user');
    expect(table.sql(), 'user');
    expect(table.sqlWithoutAlias(), 'user');
    expect(table.nameOrAlias(), 'user');
  });

  test('Table With Schema', () {
    const table = Table('user', schema: 'public');
    expect(table.sql(), 'public.user');
    expect(table.sqlWithoutAlias(), 'public.user');
    expect(table.nameOrAlias(), 'public.user');
  });

  test('Table With Alias', () {
    const table = Table('user', alias: 'u');
    expect(table.sql(), 'user AS u');
    expect(table.sqlWithoutAlias(), 'user');
    expect(table.nameOrAlias(), 'u');
  });

  test('Table With Schema And Alias', () {
    const table = Table('user', schema: 'public', alias: 'u');
    expect(table.sql(), 'public.user AS u');
    expect(table.sqlWithoutAlias(), 'public.user');
    expect(table.nameOrAlias(), 'u');
  });
}
