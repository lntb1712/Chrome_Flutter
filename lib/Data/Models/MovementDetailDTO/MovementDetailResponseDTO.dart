class MovementDetailResponseDTO {
  final String MovementCode;
  final String ProductCode;
  final String ProductName;
  final double? Demand;

  MovementDetailResponseDTO({
    required this.MovementCode,
    required this.ProductCode,
    required this.ProductName,
    required this.Demand,
  });

  factory MovementDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return MovementDetailResponseDTO(
      MovementCode: json['MovementCode'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      Demand: json['Demand'].toDouble() ?? "0.0",
    );
  }
}
