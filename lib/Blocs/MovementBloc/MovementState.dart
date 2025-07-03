import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';

import '../../Data/Models/MovementDTO/MovementResponseDTO.dart';

abstract class MovementState {}

class MovementInitial extends MovementState {}

class MovementLoading extends MovementState {}

class MovementLoaded extends MovementState {
  final PagedResponse<MovementResponseDTO> movements;

  MovementLoaded({required this.movements});
}

class MovementError extends MovementState {
  final String message;

  MovementError({required this.message});
}
