import '../../Data/Models/AccountDTO/AccountResponseDTO.dart';
import '../../Data/Models/LoginDTO/LoginResponseDTO.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class Authenticated extends LoginState {
  final LoginResponseDTO? loginResponseDTO;
  final AccountResponseDTO? accountResponseDTO;

  Authenticated({
    required this.loginResponseDTO,
    required this.accountResponseDTO,
  });
}

class LoginFailed extends LoginState {
  final String errorMessage;

  LoginFailed({required this.errorMessage});
}

class Logout extends LoginState {}
