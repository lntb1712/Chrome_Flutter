class StockInRequestDTO {
  final String StockInCode;
  final String OrderTypeCode;
  final String WarehouseCode;
  final String SupplierCode;
  final String Responsible;
  final String StatusId;
  final String OrderDeadLine;
  final String StockInDescription;

  StockInRequestDTO({
    required this.StockInCode,
    required this.OrderTypeCode,
    required this.WarehouseCode,
    required this.SupplierCode,
    required this.Responsible,
    required this.StatusId,
    required this.OrderDeadLine,
    required this.StockInDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      "StockInCode": StockInCode,
      "OrderTypeCode": OrderTypeCode,
      "WarehouseCode": WarehouseCode,
      "SupplierCode": SupplierCode,
      "Responsible": Responsible,
      "StatusId": StatusId,
      "OrderDeadLine": OrderDeadLine,
      "StockInDescription": StockInDescription,
    };
  }
}
