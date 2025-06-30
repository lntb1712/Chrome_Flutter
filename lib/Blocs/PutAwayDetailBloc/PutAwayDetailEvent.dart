import '../../Data/Models/PutAwayDetailDTO/PutAwayDetailRequestDTO.dart';

abstract class PutAwayDetailEvent {}

class FetchPutAwayDetail extends PutAwayDetailEvent {
  final String putAwayCode;

  FetchPutAwayDetail({required this.putAwayCode});
}

class UpdatePutAwayDetail extends PutAwayDetailEvent {
  final PutAwayDetailRequestDTO putAwayDetailRequestDTO;

  UpdatePutAwayDetail({required this.putAwayDetailRequestDTO});
}
