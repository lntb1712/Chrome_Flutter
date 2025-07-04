abstract class StockTakeEvent {}

class FetchStockTakeEvent extends StockTakeEvent {
  final int page;

  FetchStockTakeEvent({required this.page});
}

class FetchStockTakeFilteredEvent extends StockTakeEvent {
  final int page;
  final String textToSearch;

  FetchStockTakeFilteredEvent({required this.textToSearch, required this.page});
}
