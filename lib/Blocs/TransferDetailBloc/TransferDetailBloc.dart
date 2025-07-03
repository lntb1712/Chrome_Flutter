import 'package:chrome_flutter/Blocs/TransferDetailBloc/TransferDetailEvent.dart';
import 'package:chrome_flutter/Blocs/TransferDetailBloc/TransferDetailState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/TransferDetailRepository/TransferDetailRepository.dart';

class TransferDetailBloc
    extends Bloc<TransferDetailEvent, TransferDetailState> {
  final TransferDetailRepository transferDetailRepository;

  TransferDetailBloc({required this.transferDetailRepository})
    : super(TransferDetailInitial()) {
    on<FetchTransferDetailEvent>(_fetchTransferDetail);
  }

  Future<void> _fetchTransferDetail(
    FetchTransferDetailEvent event,
    Emitter<TransferDetailState> emit,
  ) async {
    emit(TransferDetailLoading());
    try {
      final transferDetails =
          await transferDetailRepository.GetTransferDetailsByTransferCode(
            event.transferCode,
          );
      emit(TransferDetailLoaded(transfers: transferDetails.Data!.Data));
    } catch (e) {
      emit(TransferDetailError(message: e.toString()));
    }
  }
}
