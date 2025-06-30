class QRGeneratorRequestDTO {
  final String ProductCode;
  final String LotNo;

  QRGeneratorRequestDTO({required this.ProductCode, required this.LotNo});

  Map<String, dynamic> toJson() => {"ProductCode": ProductCode, "LotNo": LotNo};
}
