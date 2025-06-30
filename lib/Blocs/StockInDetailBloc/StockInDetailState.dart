import '../../Data/Models/StockInDetailDTO/StockInDetailResponseDTO.dart';

abstract class StockInDetailState {}

class StockInDetailInitial extends StockInDetailState {}

class StockInDetailLoading extends StockInDetailState {}

class StockInDetailLoaded extends StockInDetailState {
  final List<StockInDetailResponseDTO> stockInDetail;

  StockInDetailLoaded({required this.stockInDetail});
}

class StockInDetailError extends StockInDetailState {
  final String message;

  StockInDetailError({required this.message});
}

class StockInDetailSuccess extends StockInDetailState {
  final String message;

  StockInDetailSuccess({required this.message});
}
