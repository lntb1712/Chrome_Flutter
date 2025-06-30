import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/Repositories/LoginRepository/LoginRepository.dart';
import 'LoginEvent.dart';
import 'LoginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<AuthenticationUser>(_onAuthenticationUser);
    on<LogoutEvent>(_onLogoutEvent);
    on<AppClosedEvent>(_onAppClosedEvent);
  }

  Future<void> _onAuthenticationUser(
    AuthenticationUser event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final response = await loginRepository.AuthenticationUser(
      event.loginRequestDTO,
    );

    final token = response.Data?.Token;

    if (token != null && token.isNotEmpty) {
      final accountResponseDTO = await loginRepository.getUserInformation(
        event.loginRequestDTO.Username,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', token);
      prefs.setString('full_name', accountResponseDTO.Data?.FullName ?? '');
      final locations = accountResponseDTO.Data?.ApplicableLocations;

      final selectedLocations = (locations ?? [])
          .where((e) => e.IsSelected == true)
          .map((e) => e.ApplicableLocation)
          .join(', ');
      prefs.setString('applicable_location', selectedLocations);
      emit(
        Authenticated(
          loginResponseDTO: response.Data,
          accountResponseDTO: accountResponseDTO.Data,
        ),
      );

      prefs.setString('user_name', event.loginRequestDTO.Username);
    } else {
      emit(LoginFailed(errorMessage: response.Message));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      emit(LoginFailed(errorMessage: e.toString()));
    }
  }

  Future<void> _onAppClosedEvent(
    AppClosedEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      emit(LoginFailed(errorMessage: e.toString()));
    }
  }
}
