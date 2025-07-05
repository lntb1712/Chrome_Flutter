class PutAwayDetailResponseDTO {
  final String PutAwayCode;
  final String ProductCode;
  final String ProductName;
  final String LotNo;
  final double? Demand;
  final double? Quantity;

  PutAwayDetailResponseDTO({
    required this.PutAwayCode,
    required this.ProductCode,
    required this.ProductName,
    required this.LotNo,
    required this.Demand,
    required this.Quantity,
  });

  factory PutAwayDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return PutAwayDetailResponseDTO(
      PutAwayCode: json['PutAwayCode'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      LotNo: json['LotNo'] ?? "",
      Demand: json['Demand'].toDouble() ?? "0.0",
      Quantity: json['Quantity'].toDouble() ?? "0.0",
    );
  }
}
