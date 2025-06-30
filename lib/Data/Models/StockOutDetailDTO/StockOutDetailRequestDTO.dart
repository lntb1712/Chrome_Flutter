class StockOutDetailRequestDTO {
  final String StockOutCode;
  final String ProductCode;
  final double? Demand;
  final double? Quantity;

  StockOutDetailRequestDTO({
    required this.StockOutCode,
    required this.ProductCode,
    required this.Demand,
    required this.Quantity,
  });

  Map<String, dynamic> toJson() => {
    'StockOutCode': StockOutCode,
    'ProductCode': ProductCode,
    'Demand': Demand,
    'Quantity': Quantity,
  };
}
