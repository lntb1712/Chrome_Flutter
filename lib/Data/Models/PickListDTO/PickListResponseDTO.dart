class PickListResponseDTO {
  final String PickNo;
  final String ReservationCode;
  final String WarehouseCode;
  final String WarehouseName;
  final String Responsible;
  final String FullNameResponsible;
  final String PickDate;
  final int StatusId;
  final String StatusName;

  PickListResponseDTO({
    required this.PickNo,
    required this.ReservationCode,
    required this.WarehouseCode,
    required this.WarehouseName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.PickDate,
    required this.StatusId,
    required this.StatusName,
  });

  factory PickListResponseDTO.fromJson(Map<String, dynamic> json) {
    return PickListResponseDTO(
      PickNo: json['PickNo'],
      ReservationCode: json['ReservationCode'],
      WarehouseCode: json['WarehouseCode'],
      WarehouseName: json['WarehouseName'],
      Responsible: json['Responsible'],
      FullNameResponsible: json['FullNameResponsible'],
      PickDate: json['PickDate'],
      StatusId: json['StatusId'],
      StatusName: json['StatusName'],
    );
  }
}
