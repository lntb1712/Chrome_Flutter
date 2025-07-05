import '../PutAwayDetailDTO/PutAwayDetailResponseDTO.dart';

class PutAwayAndDetailResponseDTO {
  final String PutAwayCode;
  final String OrderTypeCode;
  final String OrderTypeName;
  final String LocationCode;
  final String LocationName;
  final String Responsible;
  final String FullNameResponsible;
  final int StatusId;
  final String StatusName;
  final String PutAwayDate;
  final String PutAwayDescription;

  final List<PutAwayDetailResponseDTO> putAwayDetailResponseDTOs;

  PutAwayAndDetailResponseDTO({
    required this.PutAwayCode,
    required this.OrderTypeCode,
    required this.OrderTypeName,
    required this.LocationCode,
    required this.LocationName,
    required this.Responsible,
    required this.FullNameResponsible,
    required this.StatusId,
    required this.StatusName,
    required this.PutAwayDate,
    required this.PutAwayDescription,
    required this.putAwayDetailResponseDTOs,
  });

  factory PutAwayAndDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return PutAwayAndDetailResponseDTO(
      PutAwayCode: json['PutAwayCode'] ?? "",
      OrderTypeCode: json['OrderTypeCode'] ?? "",
      OrderTypeName: json['OrderTypeName'] ?? "",
      LocationCode: json['LocationCode'] ?? "",
      LocationName: json['LocationName'] ?? "",
      Responsible: json['Responsible'] ?? "",
      FullNameResponsible: json['FullNameResponsible'] ?? "",
      StatusId: json['StatusId'] ?? "1",
      StatusName: json['StatusName'] ?? "",
      PutAwayDate: json['PutAwayDate'] ?? "",
      PutAwayDescription: json['PutAwayDescription'] ?? "",
      putAwayDetailResponseDTOs: List<PutAwayDetailResponseDTO>.from(
        json['putAwayDetailResponseDTOs'].map(
          (x) => PutAwayDetailResponseDTO.fromJson(x),
        ),
      ),
    );
  }
}
