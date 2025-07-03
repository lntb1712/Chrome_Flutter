import 'package:chrome_flutter/Blocs/TransferBloc/TransferEvent.dart';
import 'package:chrome_flutter/Blocs/TransferBloc/TransferState.dart';
import 'package:chrome_flutter/Data/Repositories/TransferRepository/TransferRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository transferRepository;

  TransferBloc({required this.transferRepository}) : super(TransferInitial()) {
    on<FetchTransferEvent>(_fetchTransfers);
    on<FetchTransferFilteredEvent>(_fetchTransfersFiltered);
  }

  Future<void> _fetchTransfers(
    FetchTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(TransferLoading());
    try {
      final transfers = await transferRepository.GetAllTransfersWithResponsible(
        event.page,
      );
      emit(TransferLoaded(transfers: transfers.Data!));
    } catch (e) {
      emit(TransferError(message: e.toString()));
    }
  }

  Future<void> _fetchTransfersFiltered(
    FetchTransferFilteredEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(TransferLoading());
    try {
      final transfers =
          await transferRepository.SearchTransfersAsyncWithResponsible(
            event.textToSearch,
            event.page,
          );
      emit(TransferLoaded(transfers: transfers.Data!));
    } catch (e) {
      emit(TransferError(message: e.toString()));
    }
  }
}
