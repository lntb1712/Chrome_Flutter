class TransferRequestDTO {
  final String TransferCode;
  final String OrderTypeCode;
  final String FromWarehouseCode;
  final String ToWarehouseCode;
  final String ToResponsible;
  final String FromResponsible;
  final int StatusId;
  final String TransferDate;
  final String TransferDescription;

  TransferRequestDTO({
    required this.TransferCode,
    required this.OrderTypeCode,
    required this.FromWarehouseCode,
    required this.ToWarehouseCode,
    required this.ToResponsible,
    required this.FromResponsible,
    required this.StatusId,
    required this.TransferDate,
    required this.TransferDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'TransferCode': TransferCode,
      'OrderTypeCode': OrderTypeCode,
      'FromWarehouseCode': FromWarehouseCode,
      'ToWarehouseCode': ToWarehouseCode,
      'ToResponsible': ToResponsible,
      'FromResponsible': FromResponsible,
      'StatusId': StatusId,
      'TransferDate': TransferDate,
      'TransferDescription': TransferDescription,
    };
  }
}
