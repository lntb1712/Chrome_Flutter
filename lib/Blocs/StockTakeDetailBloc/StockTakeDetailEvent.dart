import 'package:chrome_flutter/Data/Models/StockTakeDetailDTO/StockTakeDetailRequestDTO.dart';

abstract class StockTakeDetailEvent {}

class FetchStockTakeDetailEvent extends StockTakeDetailEvent {
  final int page;
  final String stockTakeCode;

  FetchStockTakeDetailEvent({required this.stockTakeCode, required this.page});
}

class UpdateStockTakeDetailEvent extends StockTakeDetailEvent {
  final StockTakeDetailRequestDTO stockTakeDetail;

  UpdateStockTakeDetailEvent({required this.stockTakeDetail});
}
