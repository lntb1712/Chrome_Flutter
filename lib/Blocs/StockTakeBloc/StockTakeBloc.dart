import 'package:chrome_flutter/Blocs/StockTakeBloc/StockTakeEvent.dart';
import 'package:chrome_flutter/Blocs/StockTakeBloc/StockTakeState.dart';
import 'package:chrome_flutter/Data/Repositories/StockTakeRepository/StockTakeRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockTakeBloc extends Bloc<StockTakeEvent, StockTakeState> {
  final StockTakeRepository stockTakeRepository;

  StockTakeBloc({required this.stockTakeRepository})
    : super(StockTakeInitial()) {
    on<FetchStockTakeEvent>(_fetchStockTakes);
    on<FetchStockTakeFilteredEvent>(_fetchStockTakesFiltered);
  }

  Future<void> _fetchStockTakes(
    FetchStockTakeEvent event,
    Emitter<StockTakeState> emit,
  ) async {
    emit(StockTakeLoading());

    try {
      final stockTakes =
          await stockTakeRepository.GetAllStockTakesAsyncWithResponsible(
            event.page,
          );
      emit(StockTakeLoaded(stockTakes: stockTakes.Data!));
    } catch (e) {
      emit(StockTakeError(message: e.toString()));
    }
  }

  Future<void> _fetchStockTakesFiltered(
    FetchStockTakeFilteredEvent event,
    Emitter<StockTakeState> emit,
  ) async {
    emit(StockTakeLoading());
    try {
      final stockTakes =
          await stockTakeRepository.SearchStockTakesAsyncWithResponsible(
            event.textToSearch,
            event.page,
          );
      emit(StockTakeLoaded(stockTakes: stockTakes.Data!));
    } catch (e) {
      emit(StockTakeError(message: e.toString()));
    }
  }
}
