import 'package:sqler/src/column.dart';
import 'package:sqler/src/limit.dart';
import 'package:sqler/src/order_by.dart';
import 'package:sqler/src/query.dart';
import 'package:sqler/src/query_builder.dart';
import 'package:sqler/src/table.dart';
import 'package:sqler/src/where.dart';
import 'package:test/test.dart';

const forumCat = Table('forum_cat', alias: 'c');
const id = Column('id', table: forumCat);
const title = Column('title', table: forumCat);
const description = Column('description', table: forumCat);
const mainCat = Column('main_cat', table: forumCat);
const listNo = Column('list_no', table: forumCat);
const icon = Column('icon', table: forumCat);
const pId = Column('p.id', alias: 'topic_id');
const pTitle = Column('p.title', alias: 'topic_title');
const pDate = Column('p.date');
const pUsername = Column('p.username');
const forumTopic = Table('forum_topic', alias: 'ft');
const forumPost = Table('forum_post', alias: 'fp');
const user = Table('user', alias: 'u');
const forumTopicId = Column('id', table: forumTopic);
const forumPostTopicId = Column('topic_id', table: forumPost);
const userId = Column('user_id', table: user);
const forumTopicCatId = Column('cat_id', table: forumTopic);

final sq = (QueryBuilder()
      ..from(forumTopic)
      ..column(forumTopicId)
      ..column(forumTopicCatId)
      ..column(const Column('title', table: forumTopic))
      ..column(const Column('date', table: forumPost))
      ..column(const Column('username', table: user))
      ..innerJoin(forumPost, on: [Where.eq(forumPostTopicId, forumTopicId)])
      ..innerJoin(user,
          on: [Where.eq(userId, const Column('author_id', table: forumPost))])
      ..where(Where.eq(forumTopicCatId, const Column('id', table: forumCat)))
      ..orderBy(const OrderBy(Column('date', table: forumPost),
          order: OrderType.desc))
      ..limit(const Limit(1)))
    .toQuery();

void main() {
  test('Join With SubQuery', () {
    final q = (QueryBuilder()
          ..from(forumCat)
          ..column(id)
          ..column(title)
          ..column(description)
          ..column(icon)
          ..column(pId)
          ..column(pTitle)
          ..column(pDate)
          ..column(pUsername)
          ..leftJoin(sq,
              on: [Where.eq(const Column('p.cat_id'), id)], alias: 'p')
          ..where(Where.eq(mainCat, '1'))
          ..orderBy(const OrderBy(listNo)))
        .toQuery();

    expect(
      q.sql(),
      "SELECT c.id, c.title, c.description, c.icon, p.id AS topic_id, p.title AS topic_title, p.date, p.username FROM forum_cat AS c LEFT JOIN (SELECT ft.id, ft.cat_id, ft.title, fp.date, u.username FROM forum_topic AS ft INNER JOIN forum_post AS fp ON (fp.topic_id = ft.id) INNER JOIN user AS u ON (u.user_id = fp.author_id) WHERE (ft.cat_id = c.id) ORDER BY fp.date DESC LIMIT 1) AS p ON (p.cat_id = c.id) WHERE (c.main_cat = '1') ORDER BY c.list_no ASC",
    );
  });
}
