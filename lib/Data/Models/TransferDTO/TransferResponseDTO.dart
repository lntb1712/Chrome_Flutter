class TransferResponseDTO {
  final String TransferCode;
  final String OrderTypeCode;
  final String OrderTypeName;
  final String FromWarehouseCode;
  final String FromWarehouseName;
  final String ToWarehouseCode;
  final String ToWarehouseName;
  final String ToResponsible;
  final String FullNameToResponsible;
  final String FromResponsible;
  final String FullNameFromResponsible;
  final int StatusId;
  final String StatusName;
  final String TransferDate;
  final String TransferDescription;

  TransferResponseDTO({
    required this.TransferCode,
    required this.OrderTypeCode,
    required this.OrderTypeName,
    required this.FromWarehouseCode,
    required this.FromWarehouseName,
    required this.ToWarehouseCode,
    required this.ToWarehouseName,
    required this.ToResponsible,
    required this.FullNameToResponsible,
    required this.FromResponsible,
    required this.FullNameFromResponsible,
    required this.StatusId,
    required this.StatusName,
    required this.TransferDate,
    required this.TransferDescription,
  });

  factory TransferResponseDTO.fromJson(Map<String, dynamic> json) {
    return TransferResponseDTO(
      TransferCode: json['TransferCode'] ?? "",
      OrderTypeCode: json['OrderTypeCode'] ?? "",
      OrderTypeName: json['OrderTypeName'] ?? "",
      FromWarehouseCode: json['FromWarehouseCode'] ?? "",
      FromWarehouseName: json['FromWarehouseName'] ?? "",
      ToWarehouseCode: json['ToWarehouseCode'] ?? "",
      ToWarehouseName: json['ToWarehouseName'] ?? "",
      ToResponsible: json['ToResponsible'] ?? "",
      FullNameToResponsible: json['FullNameToResponsible'] ?? "",
      FromResponsible: json['FromResponsible'] ?? "",
      FullNameFromResponsible: json['FullNameFromResponsible'] ?? "",
      StatusId: json['StatusId'] ?? "1",
      StatusName: json['StatusName'] ?? "",
      TransferDate: json['TransferDate'] ?? "",
      TransferDescription: json['TransferDescription'] ?? "",
    );
  }
}
