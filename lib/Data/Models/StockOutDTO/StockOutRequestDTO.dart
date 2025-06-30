class StockOutRequestDTO {
  final String StockOutCode;
  final String OrderTypeCode;
  final String WarehouseCode;
  final String CustomerCode;
  final String Responsible;
  final int StatusId;
  final String StockOutDate;
  final String StockOutDescription;

  StockOutRequestDTO({
    required this.StockOutCode,
    required this.OrderTypeCode,
    required this.WarehouseCode,
    required this.CustomerCode,
    required this.Responsible,
    required this.StatusId,
    required this.StockOutDate,
    required this.StockOutDescription,
  });

  Map<String, dynamic> toJson() => {
    'StockOutCode': StockOutCode,
    'OrderTypeCode': OrderTypeCode,
    'WarehouseCode': WarehouseCode,
    'CustomerCode': CustomerCode,
    'Responsible': Responsible,
    'StatusId': StatusId,
    'StockOutDate': StockOutDate,
    'StockOutDescription': StockOutDescription,
  };
}
