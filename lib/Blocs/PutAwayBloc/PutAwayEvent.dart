abstract class PutAwayEvent {}

class FetchPutAwayEvent extends PutAwayEvent {}

class FetchPutAwayFilteredEvent extends PutAwayEvent {
  final String textToSearch;

  FetchPutAwayFilteredEvent({required this.textToSearch});
}
