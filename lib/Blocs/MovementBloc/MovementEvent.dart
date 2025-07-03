abstract class MovementEvent {}

class FetchMovementEvent extends MovementEvent {
  final int page;

  FetchMovementEvent({required this.page});
}

class FetchMovementFilteredEvent extends MovementEvent {
  final String textToSearch;
  final int page;

  FetchMovementFilteredEvent({required this.textToSearch, required this.page});
}
