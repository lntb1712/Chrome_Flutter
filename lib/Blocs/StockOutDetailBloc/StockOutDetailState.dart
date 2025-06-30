import '../../Data/Models/StockOutDetailDTO/StockOutDetailResponseDTO.dart';

abstract class StockOutDetailState {}

class StockOutDetailInitial extends StockOutDetailState {}

class StockOutDetailLoading extends StockOutDetailState {}

class StockOutDetailLoaded extends StockOutDetailState {
  final List<StockOutDetailResponseDTO> StockOutDetails;

  StockOutDetailLoaded({required this.StockOutDetails});
}

class StockOutDetailError extends StockOutDetailState {
  final String message;

  StockOutDetailError({required this.message});
}
