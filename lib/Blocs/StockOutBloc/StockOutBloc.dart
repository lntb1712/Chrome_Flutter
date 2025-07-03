import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/StockOutRepository/StockOutRepository.dart';
import 'StockOutEvent.dart';
import 'StockOutState.dart';

class StockOutBloc extends Bloc<StockOutEvent, StockOutState> {
  final StockOutRepository stockOutRepository;

  StockOutBloc({required this.stockOutRepository}) : super(StockOutInitial()) {
    on<FetchStockOutEvent>(_fetchStockOut);
    on<FetchStockOutFilteredEvent>(_fetchStockOutFiltered);
  }

  Future<void> _fetchStockOut(
    FetchStockOutEvent event,
    Emitter<StockOutState> emit,
  ) async {
    emit(StockOutLoading());
    try {
      final stockOuts = await stockOutRepository.GetAllStockOutsWithResponsible(
        event.page,
      );
      emit(StockOutLoaded(stockOuts: stockOuts.Data!));
    } catch (e) {
      emit(StockOutError(message: e.toString()));
    }
  }

  Future<void> _fetchStockOutFiltered(
    FetchStockOutFilteredEvent event,
    Emitter<StockOutState> emit,
  ) async {
    emit(StockOutLoading());

    try {
      final stockOuts =
          await stockOutRepository.SearchStockOutAsyncWithResponsible(
            event.textToSearch,
            event.page,
          );
      emit(StockOutLoaded(stockOuts: stockOuts.Data!));
    } catch (e) {
      emit(StockOutError(message: e.toString()));
    }
  }
}
