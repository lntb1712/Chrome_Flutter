import '../../Data/Models/PagedResponse/PagedResponse.dart';
import '../../Data/Models/StockTakeDetailDTO/StockTakeDetailResponseDTO.dart';

abstract class StockTakeDetailState {}

class StockTakeDetailInitial extends StockTakeDetailState {}

class StockTakeDetailLoading extends StockTakeDetailState {}

class StockTakeDetailLoaded extends StockTakeDetailState {
  final PagedResponse<StockTakeDetailResponseDTO> stockTakeDetails;

  StockTakeDetailLoaded({required this.stockTakeDetails});
}

class StockTakeDetailSuccess extends StockTakeDetailState {
  final String message;

  StockTakeDetailSuccess({required this.message});
}

class StockTakeDetailError extends StockTakeDetailState {
  final String message;

  StockTakeDetailError({required this.message});
}
