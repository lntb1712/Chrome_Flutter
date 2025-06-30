class StockOutResponseDTO {
  final String StockOutCode;
  final String OrderTypeCode;
  final String OrderTypeName;
  final String WarehouseCode;
  final String WarehouseName;
  final String CustomerCode;
  final String CustomerName;
  final String Responsible;
  final String FullNameResponsible;
  final int StatusId;
  final String StatusName;
  final String StockOutDate;
  final String StockOutDescription;

  StockOutResponseDTO({
    required this.StockOutCode,
    required this.OrderTypeCode,
    required this.OrderTypeName,
    required this.WarehouseCode,
    required this.WarehouseName,
    required this.CustomerCode,
    required this.CustomerName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.StatusId,
    required this.StatusName,
    required this.StockOutDate,
    required this.StockOutDescription,
  });

  factory StockOutResponseDTO.fromJson(Map<String, dynamic> json) {
    return StockOutResponseDTO(
      StockOutCode: json['StockOutCode'],
      OrderTypeCode: json['OrderTypeCode'],
      OrderTypeName: json['OrderTypeName'],
      WarehouseCode: json['WarehouseCode'],
      WarehouseName: json['WarehouseName'],
      CustomerCode: json['CustomerCode'],
      CustomerName: json['CustomerName'],
      Responsible: json['Responsible'],
      FullNameResponsible: json['FullNameResponsible'],
      StatusId: json['StatusId'],
      StatusName: json['StatusName'],
      StockOutDate: json['StockOutDate'],
      StockOutDescription: json['StockOutDescription'],
    );
  }
}
