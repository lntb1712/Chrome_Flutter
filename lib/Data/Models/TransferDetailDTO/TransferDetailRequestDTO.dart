class TransferDetailRequestDTO {
  final String TransferCode;
  final String ProductCode;
  final double? Demand;
  final double? QuantityInBounded;
  final double? QuantityOutBounded;

  TransferDetailRequestDTO({
    required this.TransferCode,
    required this.ProductCode,
    required this.Demand,
    required this.QuantityInBounded,
    required this.QuantityOutBounded,
  });

  Map<String, dynamic> toJson() {
    return {
      'TransferCode': TransferCode,
      'ProductCode': ProductCode,
      'Demand': Demand,
      'QuantityInBounded': QuantityInBounded,
      'QuantityOutBounded': QuantityOutBounded,
    };
  }
}
