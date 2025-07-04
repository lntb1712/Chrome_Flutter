import 'package:chrome_flutter/Blocs/StockTakeDetailBloc/StockTakeDetailEvent.dart';
import 'package:chrome_flutter/Blocs/StockTakeDetailBloc/StockTakeDetailState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/StockTakeDetailRepository/StockTakeDetailRepository.dart';

class StockTakeDetailBloc
    extends Bloc<StockTakeDetailEvent, StockTakeDetailState> {
  final StockTakeDetailRepository stockTakeDetailRepository;

  StockTakeDetailBloc({required this.stockTakeDetailRepository})
    : super(StockTakeDetailInitial()) {
    on<FetchStockTakeDetailEvent>(_fetchStockTakeDetails);
    on<UpdateStockTakeDetailEvent>(_updateStockTakeDetail);
  }

  Future<void> _fetchStockTakeDetails(
    FetchStockTakeDetailEvent event,
    Emitter<StockTakeDetailState> emit,
  ) async {
    emit(StockTakeDetailLoading());
    try {
      final stockTakeDetails =
          await stockTakeDetailRepository.GetStockTakeDetailsByStockTakeCode(
            event.stockTakeCode,
            event.page,
          );
      emit(StockTakeDetailLoaded(stockTakeDetails: stockTakeDetails.Data!));
    } catch (e) {
      emit(StockTakeDetailError(message: e.toString()));
    }
  }

  Future<void> _updateStockTakeDetail(
    UpdateStockTakeDetailEvent event,
    Emitter<StockTakeDetailState> emit,
  ) async {
    emit(StockTakeDetailLoading());
    try {
      final result = await stockTakeDetailRepository.UpdateStockTakeDetail(
        event.stockTakeDetail,
      );
      emit(StockTakeDetailSuccess(message: result.Message));

      final stockTakeDetails =
          await stockTakeDetailRepository.GetStockTakeDetailsByStockTakeCode(
            event.stockTakeDetail.StocktakeCode,
            1,
          );
      emit(StockTakeDetailLoaded(stockTakeDetails: stockTakeDetails.Data!));
    } catch (e) {
      emit(StockTakeDetailError(message: e.toString()));
    }
  }
}
