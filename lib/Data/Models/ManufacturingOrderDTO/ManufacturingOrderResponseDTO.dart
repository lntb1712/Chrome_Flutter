class ManufacturingOrderResponseDTO {
  final String ManufacturingOrderCode;
  final String OrderTypeCode;
  final String OrderTypeName;
  final String ProductCode;
  final String ProductName;
  final String Bomcode;
  final String BomVersion;
  final int Quantity;
  final int QuantityProduced;
  final String ScheduleDate;
  final String Deadline;
  final String Responsible;
  final String FullNameResponsible;
  final String Lotno;
  final int StatusId;
  final String StatusName;
  final String WarehouseCode;
  final String WarehouseName;

  ManufacturingOrderResponseDTO({
    required this.ManufacturingOrderCode,
    required this.OrderTypeCode,
    required this.OrderTypeName,
    required this.ProductCode,
    required this.ProductName,
    required this.Bomcode,
    required this.BomVersion,
    required this.Quantity,
    required this.QuantityProduced,
    required this.ScheduleDate,
    required this.Deadline,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.Lotno,
    required this.StatusId,
    required this.StatusName,
    required this.WarehouseCode,
    required this.WarehouseName,
  });

  factory ManufacturingOrderResponseDTO.fromJson(Map<String, dynamic> json) {
    return ManufacturingOrderResponseDTO(
      ManufacturingOrderCode: json['ManufacturingOrderCode'] ?? "",
      OrderTypeCode: json['OrderTypeCode'] ?? "",
      OrderTypeName: json['OrderTypeName'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      Bomcode: json['Bomcode'] ?? "",
      BomVersion: json['BomVersion'] ?? "",
      Quantity: json['Quantity'] ?? "0",
      QuantityProduced: json['QuantityProduced'] ?? "0",
      ScheduleDate: json['ScheduleDate'] ?? "",
      Deadline: json['Deadline'] ?? "",
      Responsible: json['Responsible'] ?? "",
      FullNameResponsible: json['FullNameResponsible'] ?? "",
      Lotno: json['Lotno'] ?? "",
      StatusId: json['StatusId'] ?? "1",
      StatusName: json['StatusName'] ?? "",
      WarehouseCode: json['WarehouseCode'] ?? "",
      WarehouseName: json['WarehouseName'] ?? "",
    );
  }
}
