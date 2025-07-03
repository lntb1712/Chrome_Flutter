abstract class StockOutDetailEvent {}

class FetchStockOutDetailEvent extends StockOutDetailEvent {
  final String stockOutCode;
  final int page;

  FetchStockOutDetailEvent({required this.stockOutCode, required this.page});
}
