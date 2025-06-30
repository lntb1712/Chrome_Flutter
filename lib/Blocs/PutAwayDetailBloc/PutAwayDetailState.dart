import '../../Data/Models/PutAwayDetailDTO/PutAwayDetailResponseDTO.dart';

abstract class PutAwayDetailState {}

class PutAwayDetailInitial extends PutAwayDetailState {}

class PutAwayDetailLoading extends PutAwayDetailState {}

class PutAwayDetailLoaded extends PutAwayDetailState {
  final List<PutAwayDetailResponseDTO> putAwayDetailResponseDTO;

  PutAwayDetailLoaded({required this.putAwayDetailResponseDTO});
}

class PutAwayDetailError extends PutAwayDetailState {
  final String message;

  PutAwayDetailError(this.message);
}

class PutAwayDetailSuccess extends PutAwayDetailState {
  final String message;

  PutAwayDetailSuccess(this.message);
}
