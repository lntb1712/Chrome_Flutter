import '../PickListDetailDTO/PickListDetailResponseDTO.dart';

class PickAndDetailResponseDTO {
  final String PickNo;
  final String ReservationCode;
  final String WarehouseCode;
  final String WarehouseName;
  final String Responsible;
  final String FullNameResponsible;
  final String PickDate;
  final int StatusId;
  final String StatusName;
  final List<PickListDetailResponseDTO> pickListDetailResponseDTOs;

  PickAndDetailResponseDTO({
    required this.PickNo,
    required this.ReservationCode,
    required this.WarehouseCode,
    required this.WarehouseName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.PickDate,
    required this.StatusId,
    required this.StatusName,
    required this.pickListDetailResponseDTOs,
  });

  factory PickAndDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return PickAndDetailResponseDTO(
      PickNo: json['PickNo'] ?? "",
      ReservationCode: json['ReservationCode'] ?? "",
      WarehouseCode: json['WarehouseCode'] ?? "",
      WarehouseName: json['WarehouseName'] ?? "",
      Responsible: json['Responsible'] ?? "",
      FullNameResponsible: json['FullNameResponsible'] ?? "",
      PickDate: json['PickDate'] ?? "",
      StatusId: json['StatusId'] ?? "",
      StatusName: json['StatusName'] ?? "",
      pickListDetailResponseDTOs:
          (json['pickListDetailResponseDTOs'] as List)
              .map((item) => PickListDetailResponseDTO.fromJson(item))
              .toList(),
    );
  }
}
