class StockTakeResponseDTO {
  final String StocktakeCode;
  final String StocktakeDate;
  final String WarehouseCode;
  final String WarehouseName;
  final String Responsible;
  final String FullNameResponsible;
  final int StatusId;
  final String StatusName;

  StockTakeResponseDTO({
    required this.StocktakeCode,
    required this.StocktakeDate,
    required this.WarehouseCode,
    required this.WarehouseName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.StatusId,
    required this.StatusName,
  });

  factory StockTakeResponseDTO.fromJson(Map<String, dynamic> json) {
    return StockTakeResponseDTO(
      StocktakeCode: json['StocktakeCode'],
      StocktakeDate: json['StocktakeDate'],
      WarehouseCode: json['WarehouseCode'],
      WarehouseName: json['WarehouseName'],
      Responsible: json['Responsible'],
      FullNameResponsible: json['FullNameResponsible'],
      StatusId: json['StatusId'],
      StatusName: json['StatusName'],
    );
  }
}
