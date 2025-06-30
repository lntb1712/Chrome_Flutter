class PutAwayResponseDTO {
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

  PutAwayResponseDTO({
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
  });

  factory PutAwayResponseDTO.fromJson(Map<String, dynamic> json) {
    return PutAwayResponseDTO(
      PutAwayCode: json['PutAwayCode'],
      OrderTypeCode: json['OrderTypeCode'],
      OrderTypeName: json['OrderTypeName'],
      LocationCode: json['LocationCode'],
      LocationName: json['LocationName'],
      Responsible: json['Responsible'],
      FullNameResponsible: json['FullNameResponsible'],
      StatusId: json['StatusId'],
      StatusName: json['StatusName'],
      PutAwayDate: json['PutAwayDate'],
      PutAwayDescription: json['PutAwayDescription'],
    );
  }
}
