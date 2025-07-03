class MovementDetailRequestDTO {
  final String MovementCode;
  final String ProductCode;
  final double? Demand;

  MovementDetailRequestDTO({
    required this.MovementCode,
    required this.ProductCode,
    required this.Demand,
  });

  Map<String, dynamic> toJson() {
    return {
      'MovementCode': MovementCode,
      'ProductCode': ProductCode,
      'Demand': Demand,
    };
  }
}
