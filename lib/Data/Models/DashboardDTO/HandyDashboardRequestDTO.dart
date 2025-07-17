class HandyDashboardRequestDTO {
  final List<String> warehouseCodes;
  final String userName;
  final int? year;
  final int? month;
  final int? quarter;

  HandyDashboardRequestDTO({
    required this.warehouseCodes,
    required this.userName,
    this.year,
    this.month,
    this.quarter,
  });

  Map<String, dynamic> toJson() => {
    "warehouseCodes": warehouseCodes,
    "userName": userName,
    "year": year,
    "month": month,
    "quarter": quarter,
  };
}
