import '../../Data/Models/StockInDetailDTO/StockInDetailRequestDTO.dart';

abstract class StockInDetailEvent {}

class FetchStockInDetailEvent extends StockInDetailEvent {
  final String stockInCode;
  final int page;

  FetchStockInDetailEvent({required this.stockInCode, required this.page});
}

class UpdateStockInDetailEvent extends StockInDetailEvent {
  final StockInDetailRequestDTO stockInDetail;

  UpdateStockInDetailEvent({required this.stockInDetail});
}
