import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';

import '../../Data/Models/StockInDTO/StockInResponseDTO.dart';

abstract class StockInState {}

class StockInInitial extends StockInState {}

class StockInLoading extends StockInState {}

class StockInLoaded extends StockInState {
  final PagedResponse<StockInResponseDTO> stockIn;

  StockInLoaded({required this.stockIn});
}

class StockInError extends StockInState {
  final String message;

  StockInError({required this.message});
}
