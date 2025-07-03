abstract class MovementDetailEvent {}

class FetchMovementDetailEvent extends MovementDetailEvent {
  final String movementCode;

  FetchMovementDetailEvent({required this.movementCode});
}
