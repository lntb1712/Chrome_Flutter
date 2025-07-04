import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';

import '../../Data/Models/StockTakeDTO/StockTakeResponseDTO.dart';

abstract class StockTakeState {}

class StockTakeInitial extends StockTakeState {}

class StockTakeLoading extends StockTakeState {}

class StockTakeLoaded extends StockTakeState {
  final PagedResponse<StockTakeResponseDTO> stockTakes;

  StockTakeLoaded({required this.stockTakes});
}

class StockTakeError extends StockTakeState {
  final String message;

  StockTakeError({required this.message});
}
