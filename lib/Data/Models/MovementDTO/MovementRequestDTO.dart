class MovementRequestDTO {
  final String MovementCode;
  final String OrderTypeCode;
  final String WarehouseCode;
  final String FromLocation;
  final String ToLocation;
  final String Responsible;
  final int StatusId;
  final String MovementDate;
  final String MovementDescription;

  MovementRequestDTO({
    required this.MovementCode,
    required this.OrderTypeCode,
    required this.WarehouseCode,
    required this.FromLocation,
    required this.ToLocation,
    required this.Responsible,
    required this.StatusId,
    required this.MovementDate,
    required this.MovementDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'MovementCode': MovementCode,
      'OrderTypeCode': OrderTypeCode,
      'WarehouseCode': WarehouseCode,
      'FromLocation': FromLocation,
      'ToLocation': ToLocation,
      'Responsible': Responsible,
      'StatusId': StatusId,
      'MovementDate': MovementDate,
      'MovementDescription': MovementDescription,
    };
  }
}
