class LoginRequestDTO {
  final String Username;
  final String Password;

  LoginRequestDTO({required this.Username, required this.Password});

  Map<String, dynamic> toJson() {
    return {"Username": Username, "Password": Password};
  }
}
