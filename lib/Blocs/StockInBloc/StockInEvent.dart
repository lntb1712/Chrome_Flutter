abstract class StockInEvent {}

class FetchStockInEvent extends StockInEvent {}

class FetchStockInFilteredEvent extends StockInEvent {
  final String textToSearch;

  FetchStockInFilteredEvent({required this.textToSearch});
}
