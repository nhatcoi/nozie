/// A page of results from the API's `PageResponse`.
class ApiPage<T> {
  const ApiPage({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  final List<T> items;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;

  bool get hasNext => page + 1 < totalPages;

  factory ApiPage.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) parse) {
    final raw = (json['items'] as List?) ?? const [];
    return ApiPage(
      items: raw.map((e) => parse(Map<String, dynamic>.from(e as Map))).toList(),
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? raw.length,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? raw.length,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  ApiPage<R> map<R>(R Function(T) f) => ApiPage<R>(
        items: items.map(f).toList(),
        page: page,
        size: size,
        totalItems: totalItems,
        totalPages: totalPages,
      );
}
