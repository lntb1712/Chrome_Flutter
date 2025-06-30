class StockInDetailRequestDTO {
  final String StockInCode;
  final String ProductCode;
  final double? Demand;
  final double? Quantity;

  StockInDetailRequestDTO({
    required this.StockInCode,
    required this.ProductCode,
    required this.Demand,
    required this.Quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'StockInCode': StockInCode,
      'ProductCode': ProductCode,
      'Demand': Demand,
      'Quantity': Quantity,
    };
  }
}
