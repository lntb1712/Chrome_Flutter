import '../../Data/Models/StockInDetailDTO/StockInDetailRequestDTO.dart';

abstract class StockInDetailEvent {}

class FetchStockInDetailEvent extends StockInDetailEvent {
  final String stockInCode;

  FetchStockInDetailEvent({required this.stockInCode});
}

class UpdateStockInDetailEvent extends StockInDetailEvent {
  final StockInDetailRequestDTO stockInDetail;

  UpdateStockInDetailEvent({required this.stockInDetail});
}
