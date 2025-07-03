import 'package:chrome_flutter/Data/Models/MovementDetailDTO/MovementDetailResponseDTO.dart';

abstract class MovementDetailState {}

class MovementDetailInitial extends MovementDetailState {}

class MovementDetailLoading extends MovementDetailState {}

class MovementDetailLoaded extends MovementDetailState {
  final List<MovementDetailResponseDTO> movements;

  MovementDetailLoaded({required this.movements});
}

class MovementDetailError extends MovementDetailState {
  final String message;

  MovementDetailError({required this.message});
}
