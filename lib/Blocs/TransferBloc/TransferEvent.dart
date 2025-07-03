abstract class TransferEvent {}

class FetchTransferEvent extends TransferEvent {
  final int page;

  FetchTransferEvent({required this.page});
}

class FetchTransferFilteredEvent extends TransferEvent {
  final String textToSearch;
  final int page;

  FetchTransferFilteredEvent({required this.textToSearch, required this.page});
}
