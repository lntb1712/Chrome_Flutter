import '../../Data/Models/TransferDetailDTO/TransferDetailResponseDTO.dart';

abstract class TransferDetailState {}

class TransferDetailInitial extends TransferDetailState {}

class TransferDetailLoading extends TransferDetailState {}

class TransferDetailLoaded extends TransferDetailState {
  final List<TransferDetailResponseDTO> transfers;

  TransferDetailLoaded({required this.transfers});
}

class TransferDetailError extends TransferDetailState {
  final String message;

  TransferDetailError({required this.message});
}
