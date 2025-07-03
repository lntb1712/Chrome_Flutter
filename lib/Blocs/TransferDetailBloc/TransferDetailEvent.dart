abstract class TransferDetailEvent {}

class FetchTransferDetailEvent extends TransferDetailEvent {
  final String transferCode;

  FetchTransferDetailEvent({required this.transferCode});
}
