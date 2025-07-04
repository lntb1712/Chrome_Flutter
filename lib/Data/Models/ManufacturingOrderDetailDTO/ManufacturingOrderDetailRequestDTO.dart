class ManufacturingOrderDetailRequestDTO {
  final String ManufacturingOrderCode;
  final String ComponentCode;
  final double ToConsumeQuantity;
  final double ConsumedQuantity;
  final double ScraptRate;

  ManufacturingOrderDetailRequestDTO({
    required this.ManufacturingOrderCode,
    required this.ComponentCode,
    required this.ToConsumeQuantity,
    required this.ConsumedQuantity,
    required this.ScraptRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'ManufacturingOrderCode': ManufacturingOrderCode,
      'ComponentCode': ComponentCode,
      'ToConsumeQuantity': ToConsumeQuantity,
      'ConsumedQuantity': ConsumedQuantity,
      'ScraptRate': ScraptRate,
    };
  }
}
