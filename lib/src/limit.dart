import 'package:equatable/equatable.dart';

import 'expression.dart';

class Limit extends Equatable implements Expression {
  final int limit;
  final int offset;

  const Limit(
    this.limit, {
    this.offset,
  }) : assert(limit != null);

  const Limit.paginate(
    int page, {
    int perPage = 10,
  })  : assert(page != null && page > 0),
        assert(perPage != null && perPage > 0),
        limit = 10,
        offset = (page - 1) * perPage;

  const Limit.offset(this.offset)
      : assert(offset != null && offset > 0),
        limit = -1;

  @override
  String toSql() {
    final sb = StringBuffer();

    sb.write('LIMIT $limit');

    if (offset != null) {
      sb.write(' OFFSET $offset');
    }

    return sb.toString();
  }

  @override
  List<Object> get props => [limit, offset];
}
