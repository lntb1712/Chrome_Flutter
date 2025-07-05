class StockTakeDetailResponseDTO {
  final String StocktakeCode;
  final String ProductCode;
  final String ProductName;
  final String Lotno;
  final String LocationCode;

  final double? Quantity;
  final double? CountedQuantity;

  StockTakeDetailResponseDTO({
    required this.StocktakeCode,
    required this.ProductCode,
    required this.ProductName,
    required this.Lotno,
    required this.LocationCode,
    required this.Quantity,
    required this.CountedQuantity,
  });

  factory StockTakeDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return StockTakeDetailResponseDTO(
      StocktakeCode: json['StocktakeCode'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      Lotno: json['Lotno'] ?? "",
      LocationCode: json['LocationCode'] ?? "",
      Quantity: json['Quantity'].toDouble() ?? "0.0",
      CountedQuantity: json['CountedQuantity'].toDouble() ?? "0.0",
    );
  }
}
