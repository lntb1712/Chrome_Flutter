abstract class PickListEvent {}

class FetchPickListEvent extends PickListEvent {}

class FetchPickListFilteredEvent extends PickListEvent {
  final String textToSearch;

  FetchPickListFilteredEvent({required this.textToSearch});
}

class FetchPickAndDetailEvent extends PickListEvent {
  final String orderCode;

  FetchPickAndDetailEvent({required this.orderCode});
}
