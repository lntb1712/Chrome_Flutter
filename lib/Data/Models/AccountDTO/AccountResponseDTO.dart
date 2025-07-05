import 'package:chrome_flutter/Data/Models/ApplicableLocationDTO/ApplicableLocationResponseDTO.dart';

class AccountResponseDTO {
  final String UserName;
  final String Password;
  final String FullName;
  final String GroupID;
  final String GroupName;
  final List<ApplicableLocationResponseDTO> ApplicableLocations;

  AccountResponseDTO({
    required this.UserName,
    required this.Password,
    required this.FullName,
    required this.GroupID,
    required this.GroupName,
    required this.ApplicableLocations,
  });

  factory AccountResponseDTO.fromJson(Map<String, dynamic> json) {
    return AccountResponseDTO(
      UserName: json['UserName'] ?? "",
      Password: json['Password'] ?? "",
      FullName: json['FullName'] ?? "",
      GroupID: json['GroupID'] ?? "",
      GroupName: json['GroupName'] ?? "",
      ApplicableLocations:
          (json['ApplicableLocations'] as List)
              .map(
                (location) => ApplicableLocationResponseDTO.fromJson(location),
              )
              .toList(),
    );
  }
}
