class PagedResponse<T> {
  final List<T> Data;
  final int CurrentPage;
  final int TotalPages;
  final int TotalItems;
  final int PageSize;

  PagedResponse({
    required this.Data,
    required this.CurrentPage,
    required this.TotalPages,
    required this.TotalItems,
    required this.PageSize,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final totalItems = json['TotalItems'] as int;
    final pageSize = json['PageSize'] as int;
    final totalPages = (totalItems / pageSize).ceil();
    return PagedResponse<T>(
      Data:
          (json['Data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
      CurrentPage: json['CurrentPage'] as int,
      TotalPages: totalPages,
      TotalItems: totalItems,
      PageSize: pageSize,
    );
  }
}
