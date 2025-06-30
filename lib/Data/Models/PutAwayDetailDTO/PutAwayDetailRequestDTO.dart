class PutAwayDetailRequestDTO {
  final String PutAwayCode;
  final String ProductCode;
  final String LotNo;
  final double? Demand;
  final double? Quantity;

  PutAwayDetailRequestDTO({
    required this.PutAwayCode,
    required this.ProductCode,
    required this.LotNo,
    required this.Demand,
    required this.Quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'PutAwayCode': PutAwayCode,
      'ProductCode': ProductCode,
      'LotNo': LotNo,
      'Demand': Demand,
      'Quantity': Quantity,
    };
  }
}
