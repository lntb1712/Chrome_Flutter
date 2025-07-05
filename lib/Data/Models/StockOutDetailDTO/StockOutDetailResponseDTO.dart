class StockOutDetailResponseDTO {
  final String StockOutCode;
  final String ProductCode;
  final String ProductName;
  final double? Demand;
  final double? Quantity;

  StockOutDetailResponseDTO({
    required this.StockOutCode,
    required this.ProductCode,
    required this.ProductName,
    required this.Demand,
    required this.Quantity,
  });

  factory StockOutDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return StockOutDetailResponseDTO(
      StockOutCode: json['StockOutCode'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      Demand: json['Demand'].toDouble() ?? "0.0",
      Quantity: json['Quantity'].toDouble() ?? "0.0",
    );
  }
}
