

abstract class StockOutDetailEvent {}

class FetchStockOutDetailEvent extends StockOutDetailEvent {
  final String stockOutCode;

  FetchStockOutDetailEvent({required this.stockOutCode});
}
