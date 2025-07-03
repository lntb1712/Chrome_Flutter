import '../../Data/Models/PagedResponse/PagedResponse.dart';
import '../../Data/Models/TransferDTO/TransferResponseDTO.dart';

abstract class TransferState {}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferLoaded extends TransferState {
  final PagedResponse<TransferResponseDTO> transfers;

  TransferLoaded({required this.transfers});
}

class TransferError extends TransferState {
  final String message;

  TransferError({required this.message});
}
