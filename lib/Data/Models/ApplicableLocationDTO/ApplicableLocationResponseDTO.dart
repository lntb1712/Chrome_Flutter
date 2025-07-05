class ApplicableLocationResponseDTO {
  final String ApplicableLocation;
  final bool IsSelected;

  ApplicableLocationResponseDTO({
    required this.ApplicableLocation,
    required this.IsSelected,
  });

  factory ApplicableLocationResponseDTO.fromJson(Map<String, dynamic> json) {
    return ApplicableLocationResponseDTO(
      ApplicableLocation: json['ApplicableLocation'] ?? "",
      IsSelected: json['IsSelected'] ?? "",
    );
  }
}
