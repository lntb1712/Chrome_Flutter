class PickListDetailResponseDTO {
  final String PickNo;
  final String ProductCode;
  final String ProductName;
  final String LotNo;
  final double? Demand;
  final double? Quantity;
  final String LocationCode;
  final String LocationName;

  PickListDetailResponseDTO({
    required this.PickNo,
    required this.ProductCode,
    required this.ProductName,
    required this.LotNo,
    required this.Demand,
    required this.Quantity,
    required this.LocationCode,
    required this.LocationName,
  });

  factory PickListDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return PickListDetailResponseDTO(
      PickNo: json['PickNo'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      LotNo: json['LotNo'] ?? "",
      Demand: json['Demand'].toDouble() ?? "0.0",
      Quantity: json['Quantity'].toDouble() ?? "0.0",
      LocationCode: json['LocationCode'] ?? "",
      LocationName: json['LocationName'] ?? "",
    );
  }
}
