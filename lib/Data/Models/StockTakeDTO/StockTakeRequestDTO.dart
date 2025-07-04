class StockTakeRequestDTO {
  final String StocktakeCode;
  final String StocktakeDate;
  final String WarehouseCode;
  final String Responsible;

  StockTakeRequestDTO({
    required this.StocktakeCode,
    required this.StocktakeDate,
    required this.WarehouseCode,
    required this.Responsible,
  });

  Map<String, dynamic> toJson() {
    return {
      'StocktakeCode': StocktakeCode,
      'StocktakeDate': StocktakeDate,
      'WarehouseCode': WarehouseCode,
      'Responsible': Responsible,
    };
  }
}
