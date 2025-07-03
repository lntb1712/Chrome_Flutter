import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';

import '../../Data/Models/StockInDetailDTO/StockInDetailResponseDTO.dart';

abstract class StockInDetailState {}

class StockInDetailInitial extends StockInDetailState {}

class StockInDetailLoading extends StockInDetailState {}

class StockInDetailLoaded extends StockInDetailState {
  final PagedResponse<StockInDetailResponseDTO> stockInDetail;

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
