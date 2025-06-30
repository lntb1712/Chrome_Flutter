import 'package:chrome_flutter/Blocs/StockInDetailBloc/StockInDetailEvent.dart';
import 'package:chrome_flutter/Blocs/StockInDetailBloc/StockInDetailState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/StockInDetailRepository/StockInDetailRepository.dart';

class StockInDetailBloc extends Bloc<StockInDetailEvent, StockInDetailState> {
  final StockInDetailRepository stockInDetailRepository;

  StockInDetailBloc({required this.stockInDetailRepository})
    : super(StockInDetailInitial()) {
    on<FetchStockInDetailEvent>(_fetchStockInDetail);
    on<UpdateStockInDetailEvent>(_updateStockInDetail);
  }

  Future<void> _fetchStockInDetail(
    FetchStockInDetailEvent event,
    Emitter<StockInDetailState> emit,
  ) async {
    emit(StockInDetailLoading());
    try {
      final stockInDetail = await stockInDetailRepository.getAllStockInDetails(
        event.stockInCode,
      );
      emit(StockInDetailLoaded(stockInDetail: stockInDetail.Data!.Data));
    } catch (e) {
      emit(StockInDetailError(message: e.toString()));
    }
  }

  Future<void> _updateStockInDetail(
    UpdateStockInDetailEvent event,
    Emitter<StockInDetailState> emit,
  ) async {
    emit(StockInDetailLoading());

    try {
      final stockInDetail = await stockInDetailRepository.UpdateStockInDetail(
        event.stockInDetail,
      );
      if (stockInDetail.Success) {
        emit(StockInDetailSuccess(message: stockInDetail.Message));
        final stockInDetailResponse = await stockInDetailRepository
            .getAllStockInDetails(event.stockInDetail.StockInCode);
        emit(
          StockInDetailLoaded(stockInDetail: stockInDetailResponse.Data!.Data),
        );
      }
    } catch (e) {
      emit(StockInDetailError(message: e.toString()));
    }
  }
}
