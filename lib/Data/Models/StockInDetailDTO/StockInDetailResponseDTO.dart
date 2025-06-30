class StockInDetailResponseDTO {
  final String StockInCode;
  final String ProductCode;
  final String ProductName;
  final String Lotno;
  final double? Demand;
  final double? Quantity;

  StockInDetailResponseDTO({
    required this.StockInCode,
    required this.ProductCode,
    required this.ProductName,
    required this.Lotno,
    required this.Demand,
    required this.Quantity,
  });

  factory StockInDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return StockInDetailResponseDTO(
      StockInCode: json['StockInCode'],
      ProductCode: json['ProductCode'],
      ProductName: json['ProductName'],
      Lotno: json['LotNo'],
      Demand: json['Demand'].toDouble(),
      Quantity: json['Quantity'].toDouble(),
    );
  }
}
