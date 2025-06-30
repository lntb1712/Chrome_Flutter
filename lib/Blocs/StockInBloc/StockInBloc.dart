import 'package:chrome_flutter/Data/Repositories/StockInRepository/StockInRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'StockInEvent.dart';
import 'StockInState.dart';

class StockInBloc extends Bloc<StockInEvent, StockInState> {
  final StockInRepository stockInRepository;

  StockInBloc({required this.stockInRepository}) : super(StockInInitial()) {
    on<FetchStockInEvent>(_fetchStockIn);
    on<FetchStockInFilteredEvent>(_fetchStockInFiltered);
  }

  Future<void> _fetchStockIn(
    FetchStockInEvent event,
    Emitter<StockInState> emit,
  ) async {
    emit(StockInLoading());
    try {
      final stockIn = await stockInRepository.getAllStockInWithResponsible();
      emit(StockInLoaded(stockIn: stockIn.Data!.Data));
    } catch (e) {
      emit(StockInError(message: e.toString()));
    }
  }

  Future<void> _fetchStockInFiltered(
    FetchStockInFilteredEvent event,
    Emitter<StockInState> emit,
  ) async {
    emit(StockInLoading());
    try {
      final stockIn = await stockInRepository.searchStockInWithResponsible(
        event.textToSearch,
      );
      emit(StockInLoaded(stockIn: stockIn.Data!.Data));
    } catch (e) {
      emit(StockInError(message: e.toString()));
    }
  }
}
