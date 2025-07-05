class ManufacturingOrderDetailResponseDTO {
  final String ManufacturingOrderCode;
  final String ComponentCode;
  final String ComponentName;
  final double ToConsumeQuantity;
  final double ConsumedQuantity;
  final double ScraptRate;

  ManufacturingOrderDetailResponseDTO({
    required this.ManufacturingOrderCode,
    required this.ComponentCode,
    required this.ComponentName,
    required this.ToConsumeQuantity,
    required this.ConsumedQuantity,
    required this.ScraptRate,
  });

  factory ManufacturingOrderDetailResponseDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ManufacturingOrderDetailResponseDTO(
      ManufacturingOrderCode: json['ManufacturingOrderCode'] ?? "",
      ComponentCode: json['ComponentCode'] ?? "",
      ComponentName: json['ComponentName'] ?? "",
      ToConsumeQuantity: json['ToConsumeQuantity'].toDouble() ?? "0.0",
      ConsumedQuantity: json['ConsumedQuantity'].toDouble() ?? "0.0",
      ScraptRate: json['ScraptRate'].toDouble() ?? "0.0",
    );
  }
}
