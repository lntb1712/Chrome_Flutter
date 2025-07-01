class PickListRequestDTO {
  final String PickNo;
  final String ReservationCode;
  final String WarehouseCode;
  final String Responsible;
  final String PickDate;
  final int StatusId;

  PickListRequestDTO({
    required this.PickNo,
    required this.ReservationCode,
    required this.WarehouseCode,
    required this.Responsible,
    required this.PickDate,
    required this.StatusId,
  });

  Map<String, dynamic> toMap() {
    return {
      'PickNo': PickNo,
      'ReservationCode': ReservationCode,
      'WarehouseCode': WarehouseCode,
      'Responsible': Responsible,
      'PickDate': PickDate,
      'StatusId': StatusId,
    };
  }
}
