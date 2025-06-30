import '../../Data/Models/StockOutDTO/StockOutResponseDTO.dart';

abstract class StockOutState {}

class StockOutInitial extends StockOutState {}

class StockOutLoading extends StockOutState {}

class StockOutLoaded extends StockOutState {
  final List<StockOutResponseDTO> stockOuts;

  StockOutLoaded({required this.stockOuts});
}

class StockOutError extends StockOutState {
  final String message;

  StockOutError({required this.message});
}
