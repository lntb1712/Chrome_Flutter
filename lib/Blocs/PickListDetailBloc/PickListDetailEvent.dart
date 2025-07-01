import '../../Data/Models/PickListDetailDTO/PickListDetailRequestDTO.dart';

abstract class PickListDetailEvent {}

class FetchPickListDetailEvent extends PickListDetailEvent {
  final String pickNo;

  FetchPickListDetailEvent({required this.pickNo});
}

class UpdatePickListDetailEvent extends PickListDetailEvent {
  final PickListDetailRequestDTO pickListDetailRequestDTO;

  UpdatePickListDetailEvent({required this.pickListDetailRequestDTO});
}
