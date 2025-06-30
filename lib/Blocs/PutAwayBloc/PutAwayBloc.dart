import 'package:chrome_flutter/Data/Repositories/PutAwayRepository/PutAwayRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'PutAwayEvent.dart';
import 'PutAwayState.dart';

class PutAwayBloc extends Bloc<PutAwayEvent, PutAwayState> {
  final PutAwayRepository putAwayRepository;

  PutAwayBloc({required this.putAwayRepository}) : super(PutAwayInitial()) {
    on<FetchPutAwayEvent>(_fetchPutAway);
    on<FetchPutAwayFilteredEvent>(_fetchPutAwayFiltered);
  }

  Future<void> _fetchPutAway(
    FetchPutAwayEvent event,
    Emitter<PutAwayState> emit,
  ) async {
    emit(PutAwayLoading());

    try {
      final putAways =
          await putAwayRepository.getAllPutAwaysAsyncWithResponsible();
      emit(PutAwayLoaded(putAwayResponses: putAways.Data!.Data));
    } catch (e) {
      emit(PutAwayError(e.toString()));
    }
  }

  Future<void> _fetchPutAwayFiltered(
    FetchPutAwayFilteredEvent event,
    Emitter<PutAwayState> emit,
  ) async {
    emit(PutAwayLoading());
    try {
      final putAways = await putAwayRepository
          .searchPutAwaysAsyncWithResponsible(event.textToSearch);
      emit(PutAwayLoaded(putAwayResponses: putAways.Data!.Data));
    } catch (e) {
      emit(PutAwayError(e.toString()));
    }
  }
}
