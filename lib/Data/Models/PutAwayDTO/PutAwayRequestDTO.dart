class PutAwayRequestDTO {
  final String PutAwayCode;
  final String OrderTypeCode;
  final String LocationCode;
  final String Responsible;
  final int StatusId;
  final String PutAwayDate;
  final String PutAwayDescription;

  PutAwayRequestDTO({
    required this.PutAwayCode,
    required this.OrderTypeCode,
    required this.LocationCode,
    required this.Responsible,
    required this.StatusId,
    required this.PutAwayDate,
    required this.PutAwayDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'PutAwayCode': PutAwayCode,
      'OrderTypeCode': OrderTypeCode,
      'LocationCode': LocationCode,
      'Responsible': Responsible,
      'StatusId': StatusId,
      'PutAwayDate': PutAwayDate,
      'PutAwayDescription': PutAwayDescription,
    };
  }
}
