class TransferDetailResponseDTO {
  final String TransferCode;
  final String ProductCode;
  final String ProductName;
  final double? Demand;
  final double? QuantityInBounded;
  final double? QuantityOutBounded;

  TransferDetailResponseDTO({
    required this.TransferCode,
    required this.ProductCode,
    required this.ProductName,
    required this.Demand,
    required this.QuantityInBounded,
    required this.QuantityOutBounded,
  });

  factory TransferDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return TransferDetailResponseDTO(
      TransferCode: json['TransferCode'] ?? "",
      ProductCode: json['ProductCode'] ?? "",
      ProductName: json['ProductName'] ?? "",
      Demand: json['Demand'].toDouble() ?? "0.0",
      QuantityInBounded: json['QuantityInBounded'].toDouble() ?? "0.0",
      QuantityOutBounded: json['QuantityOutBounded'].toDouble() ?? "0.0",
    );
  }
}
