abstract class StockOutEvent {}

class FetchStockOutEvent extends StockOutEvent {}

class FetchStockOutFilteredEvent extends StockOutEvent {
  final String textToSearch;

  FetchStockOutFilteredEvent({required this.textToSearch});
}
