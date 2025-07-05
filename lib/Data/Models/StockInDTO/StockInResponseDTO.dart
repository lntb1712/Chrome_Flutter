class StockInResponseDTO {
  final String StockInCode;
  final String OrderTypeCode;
  final String OrderTypeName;
  final String WarehouseCode;
  final String WarehouseName;
  final String SupplierCode;
  final String SupplierName;
  final String Responsible;
  final String FullNameResponsible;
  final int StatusId;
  final String StatusName;
  final String OrderDeadLine;
  final String? StockInDescription;

  StockInResponseDTO({
    required this.StockInCode,
    required this.OrderTypeCode,
    required this.OrderTypeName,
    required this.WarehouseCode,
    required this.WarehouseName,
    required this.SupplierCode,
    required this.SupplierName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.StatusId,
    required this.StatusName,
    required this.OrderDeadLine,
    required this.StockInDescription,
  });

  factory StockInResponseDTO.fromJson(Map<String, dynamic> json) {
    return StockInResponseDTO(
      StockInCode: json['StockInCode'] ?? "",
      OrderTypeCode: json['OrderTypeCode'] ?? "",
      OrderTypeName: json['OrderTypeName'] ?? "",
      WarehouseCode: json['WarehouseCode'] ?? "",
      WarehouseName: json['WarehouseName'] ?? "",
      SupplierCode: json['SupplierCode'] ?? "",
      SupplierName: json['SupplierName'] ?? "",
      Responsible: json['Responsible'] ?? "",
      FullNameResponsible: json['FullNameResponsible'] ?? "",
      StatusId: json['StatusId'] ?? "",
      StatusName: json['StatusName'] ?? "",
      OrderDeadLine: json['OrderDeadline'] ?? "",
      StockInDescription: json['StockInDescription'] ?? "",
    );
  }
}
