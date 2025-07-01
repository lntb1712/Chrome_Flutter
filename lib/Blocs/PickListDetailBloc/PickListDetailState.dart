import '../../Data/Models/PickListDetailDTO/PickListDetailResponseDTO.dart';

abstract class PickListDetailState {}

class PickListDetailInitial extends PickListDetailState {}

class PickListDetailLoading extends PickListDetailState {}

class PickListDetailLoaded extends PickListDetailState {
  final List<PickListDetailResponseDTO> pickListDetails;

  PickListDetailLoaded({required this.pickListDetails});
}

class PickListDetailSuccess extends PickListDetailState {
  final String message;

  PickListDetailSuccess({required this.message});
}

class PickListDetailError extends PickListDetailState {
  final String message;

  PickListDetailError({required this.message});
}
