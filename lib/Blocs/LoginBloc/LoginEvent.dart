import '../../Data/Models/LoginDTO/LoginRequestDTO.dart';

abstract class LoginEvent {}

class AuthenticationUser extends LoginEvent {
  final LoginRequestDTO loginRequestDTO;

  AuthenticationUser(this.loginRequestDTO);
}

class LogoutEvent extends LoginEvent {}

class AppClosedEvent extends LoginEvent {}
