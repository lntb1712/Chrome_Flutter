class PickListDetailRequestDTO {
  final String PickNo;
  final String ProductCode;
  final String LotNo;
  final double? Demand;
  final double? Quantity;
  final String LocationCode;

  PickListDetailRequestDTO({
    required this.PickNo,
    required this.ProductCode,
    required this.LotNo,
    required this.Demand,
    required this.Quantity,
    required this.LocationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'PickNo': PickNo,
      'ProductCode': ProductCode,
      'LotNo': LotNo,
      'Demand': Demand,
      'Quantity': Quantity,
      'LocationCode': LocationCode,
    };
  }
}
