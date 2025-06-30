class QRGeneratorResponseDTO {
  final bool Success;
  final String Message;
  final String FilePath;

  QRGeneratorResponseDTO({
    required this.Success,
    required this.Message,
    required this.FilePath,
  });

  factory QRGeneratorResponseDTO.fromJson(Map<String, dynamic> json) {
    return QRGeneratorResponseDTO(
      Success: json['Success'],
      Message: json['Message'],
      FilePath: json['FilePath'],
    );
  }
}
