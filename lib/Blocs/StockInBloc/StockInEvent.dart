abstract class StockInEvent {}

class FetchStockInEvent extends StockInEvent {
  final int page;

  FetchStockInEvent({required this.page});
}

class FetchStockInFilteredEvent extends StockInEvent {
  final String textToSearch;
  final int page;

  FetchStockInFilteredEvent({required this.textToSearch, required this.page});
}
