import '../../Data/Models/StockInDTO/StockInResponseDTO.dart';

abstract class StockInState {}

class StockInInitial extends StockInState {}

class StockInLoading extends StockInState {}

class StockInLoaded extends StockInState {
  final List<StockInResponseDTO> stockIn;

  StockInLoaded({required this.stockIn});
}

class StockInError extends StockInState {
  final String message;

  StockInError({required this.message});
}
