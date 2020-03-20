import 'package:sqler/src/helper.dart';
import 'package:test/test.dart';

final forumCat = table('forum_cat', alias: 'c');
final id = col('id', table: forumCat);
final title = col('title', table: forumCat);
final description = col('description', table: forumCat);
final mainCat = col('main_cat', table: forumCat);
final listNo = col('list_no', table: forumCat);
final icon = col('icon', table: forumCat);
final pId = col('p.id', alias: 'topic_id');
final pTitle = col('p.title', alias: 'topic_title');
final pDate = col('p.date');
final pUsername = col('p.username');
final forumTopic = table('forum_topic', alias: 'ft');
final forumPost = table('forum_post', alias: 'fp');
final user = table('user', alias: 'u');
final forumTopicId = col('id', table: forumTopic);
final forumPostTopicId = col('topic_id', table: forumPost);
final userId = col('user_id', table: user);
final forumTopicCatId = col('cat_id', table: forumTopic);

final sq = (QueryBuilder()
      ..from(forumTopic)
      ..column(forumTopicId)
      ..column(forumTopicCatId)
      ..column(col('title', table: forumTopic))
      ..column(col('date', table: forumPost))
      ..column(col('username', table: user))
      ..innerJoin(forumPost, on: [eq(forumPostTopicId, forumTopicId)])
      ..innerJoin(user, on: [eq(userId, col('author_id', table: forumPost))])
      ..where(eq(forumTopicCatId, col('id', table: forumCat)))
      ..orderBy(desc(col('date', table: forumPost)))
      ..limit(limit(1)))
    .toQuery();

void main() {
  test('Join With SubQuery', () {
    final q = (QueryBuilder()
          ..from(forumCat)
          ..columns(
              [id, title, description, icon, pId, pTitle, pDate, pUsername])
          ..leftJoin(sq, on: [eq(col('p.cat_id'), id)], alias: 'p')
          ..where(eq(mainCat, '1'))
          ..orderBy(asc(listNo)))
        .sql();

    expect(
      q,
      "SELECT c.id, c.title, c.description, c.icon, p.id AS topic_id, p.title AS topic_title, p.date, p.username FROM forum_cat AS c LEFT JOIN (SELECT ft.id, ft.cat_id, ft.title, fp.date, u.username FROM forum_topic AS ft INNER JOIN forum_post AS fp ON (fp.topic_id = ft.id) INNER JOIN user AS u ON (u.user_id = fp.author_id) WHERE (ft.cat_id = c.id) ORDER BY fp.date DESC LIMIT 1) AS p ON (p.cat_id = c.id) WHERE (c.main_cat = '1') ORDER BY c.list_no ASC",
    );
  });
}
