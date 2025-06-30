class LoginResponseDTO {
  final String Token;
  final String Username;
  final String GroupId;

  LoginResponseDTO({
    required this.Token,
    required this.Username,
    required this.GroupId,
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) {
    return LoginResponseDTO(
      Token: json['Token'],
      Username: json['Username'],
      GroupId: json['GroupId'],
    );
  }
}
