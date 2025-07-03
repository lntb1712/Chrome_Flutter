import 'package:chrome_flutter/Data/Models/PutAwayDTO/PutAwayAndDetailResponseDTO.dart';

import '../../Data/Models/PutAwayDTO/PutAwayResponseDTO.dart';

abstract class PutAwayState {}

class PutAwayInitial extends PutAwayState {}

class PutAwayLoading extends PutAwayState {}

class PutAwayLoaded extends PutAwayState {
  final List<PutAwayResponseDTO> putAwayResponses;

  PutAwayLoaded({required this.putAwayResponses});
}

class PutAwayAndDetailLoaded extends PutAwayState {
  final PutAwayAndDetailResponseDTO putAwayResponses;

  PutAwayAndDetailLoaded({required this.putAwayResponses});
}

class PutAwayError extends PutAwayState {
  final String message;

  PutAwayError(this.message);
}

class PutAwaySuccess extends PutAwayState {
  final String message;

  PutAwaySuccess(this.message);
}
