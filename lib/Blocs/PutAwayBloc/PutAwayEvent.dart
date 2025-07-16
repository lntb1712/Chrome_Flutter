abstract class PutAwayEvent {}

class FetchPutAwayEvent extends PutAwayEvent {
  final int page;

  FetchPutAwayEvent({required this.page});
}

class FetchPutAwayFilteredEvent extends PutAwayEvent {
  final String textToSearch;
  final int page;

  FetchPutAwayFilteredEvent({required this.textToSearch, required this.page});
}

class FetchPutAwayAndDetailEvent extends PutAwayEvent {
  final String orderCode;

  FetchPutAwayAndDetailEvent({required this.orderCode});
}

class FetchPutAwayContainsCodeEvent extends PutAwayEvent {
  final String orderCode;

  FetchPutAwayContainsCodeEvent({required this.orderCode});
}
