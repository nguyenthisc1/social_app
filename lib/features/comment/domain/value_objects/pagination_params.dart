class PaginationParams {
  final String? cursor;
  final int limit;

  const PaginationParams({this.cursor, this.limit = 20});
}
