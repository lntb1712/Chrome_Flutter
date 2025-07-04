class StockTakeDetailRequestDTO {
  final String StocktakeCode;
  final String ProductCode;
  final String Lotno;
  final String LocationCode;
  final double? Quantity;
  final double? CountedQuantity;

  StockTakeDetailRequestDTO({
    required this.StocktakeCode,
    required this.ProductCode,
    required this.Lotno,
    required this.LocationCode,
    required this.Quantity,
    required this.CountedQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'StocktakeCode': StocktakeCode,
      'ProductCode': ProductCode,
      'Lotno': Lotno,
      'LocationCode': LocationCode,
      'Quantity': Quantity,
      'CountedQuantity': CountedQuantity,
    };
  }
}
