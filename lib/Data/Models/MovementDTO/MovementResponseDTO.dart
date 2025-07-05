class MovementResponseDTO {
  final String MovementCode;
  final String OrderTypeCode;
  final String OrderTypeName;
  final String WarehouseCode;
  final String WarehouseName;
  final String FromLocation;
  final String FromLocationName;
  final String ToLocation;
  final String ToLocationName;
  final String Responsible;
  final String FullNameResponsible;
  final int StatusId;
  final String StatusName;
  final String MovementDate;
  final String? MovementDescription;

  MovementResponseDTO({
    required this.MovementCode,
    required this.OrderTypeCode,
    required this.OrderTypeName,
    required this.WarehouseCode,
    required this.WarehouseName,
    required this.FromLocation,
    required this.FromLocationName,
    required this.ToLocation,
    required this.ToLocationName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.StatusId,
    required this.StatusName,
    required this.MovementDate,
    required this.MovementDescription,
  });

  factory MovementResponseDTO.fromJson(Map<String, dynamic> json) {
    return MovementResponseDTO(
      MovementCode: json['MovementCode'] ?? "",
      OrderTypeCode: json['OrderTypeCode'] ?? "",
      OrderTypeName: json['OrderTypeName'] ?? "",
      WarehouseCode: json['WarehouseCode'] ?? "",
      WarehouseName: json['WarehouseName'] ?? "",
      FromLocation: json['FromLocation'] ?? "",
      FromLocationName: json['FromLocationName'] ?? "",
      ToLocation: json['ToLocation'] ?? "",
      ToLocationName: json['ToLocationName'] ?? "",
      Responsible: json['Responsible'] ?? "",
      FullNameResponsible: json['FullNameResponible'] ?? "",
      StatusId: json['StatusId'] ?? "",
      StatusName: json['StatusName'] ?? "",
      MovementDate: json['MovementDate'] ?? "",
      MovementDescription: json['MovementDescription'] ?? "",
    );
  }
}
