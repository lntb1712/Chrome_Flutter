class ManufacturingOrderRequestDTO {
  final String ManufacturingOrderCode;
  final String OrderTypeCode;
  final String ProductCode;
  final String Bomcode;
  final String BomVersion;
  final int Quantity;
  final int QuantityProduced;
  final String ScheduleDate;
  final String Deadline;
  final String Responsible;
  final int StatusId;
  final String WarehouseCode;

  ManufacturingOrderRequestDTO({
    required this.ManufacturingOrderCode,
    required this.OrderTypeCode,
    required this.ProductCode,
    required this.Bomcode,
    required this.BomVersion,
    required this.Quantity,
    required this.QuantityProduced,
    required this.ScheduleDate,
    required this.Deadline,
    required this.Responsible,
    required this.StatusId,
    required this.WarehouseCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'ManufacturingOrderCode': ManufacturingOrderCode,
      'OrderTypeCode': OrderTypeCode,
      'ProductCode': ProductCode,
      'Bomcode': Bomcode,
      'BomVersion': BomVersion,
      'Quantity': Quantity,
      'QuantityProduced': QuantityProduced,
      'ScheduleDate': ScheduleDate,
      'Deadline': Deadline,
      'Responsible': Responsible,
      'StatusId': StatusId,
      'WarehouseCode': WarehouseCode,
    };
  }
}
