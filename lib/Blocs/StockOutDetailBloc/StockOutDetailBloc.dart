import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/StockOutDetailRepository/StockOutDetailRepository.dart';
import 'StockOutDetailEvent.dart';
import 'StockOutDetailState.dart';

class StockOutDetailBloc
    extends Bloc<StockOutDetailEvent, StockOutDetailState> {
  final StockOutDetailRepository stockOutDetailRepository;

  StockOutDetailBloc({required this.stockOutDetailRepository})
    : super(StockOutDetailInitial()) {
    on<FetchStockOutDetailEvent>(_fetchStockOutDetail);
  }

  Future<void> _fetchStockOutDetail(
    FetchStockOutDetailEvent event,
    Emitter<StockOutDetailState> emit,
  ) async {
    emit(StockOutDetailLoading());
    try {
      final stockOutDetails =
          await stockOutDetailRepository.GetAllStockOutDetails(
            event.stockOutCode,
          );
      emit(StockOutDetailLoaded(StockOutDetails: stockOutDetails.Data!.Data));
    } catch (e) {
      emit(StockOutDetailError(message: e.toString()));
    }
  }
}
