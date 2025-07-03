abstract class StockOutEvent {}

class FetchStockOutEvent extends StockOutEvent {
  final int page;

  FetchStockOutEvent({required this.page});
}

class FetchStockOutFilteredEvent extends StockOutEvent {
  final String textToSearch;
  final int page;

  FetchStockOutFilteredEvent({required this.textToSearch, required this.page});
}
