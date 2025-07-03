abstract class TransferEvent {}

class FetchTransferEvent extends TransferEvent {}

class FetchTransferFilteredEvent extends TransferEvent {
  final String textToSearch;

  FetchTransferFilteredEvent({required this.textToSearch});
}
