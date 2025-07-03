abstract class PickListEvent {}

class FetchPickListEvent extends PickListEvent {
  final int page;

  FetchPickListEvent({required this.page});
}

class FetchPickListFilteredEvent extends PickListEvent {
  final String textToSearch;
  final int page;

  FetchPickListFilteredEvent({required this.textToSearch, required this.page});
}

class FetchPickAndDetailEvent extends PickListEvent {
  final String orderCode;

  FetchPickAndDetailEvent({required this.orderCode});
}
