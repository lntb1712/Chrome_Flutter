import 'package:chrome_flutter/Blocs/PutAwayDetailBloc/PutAwayDetailEvent.dart';
import 'package:chrome_flutter/Blocs/PutAwayDetailBloc/PutAwayDetailState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/PutAwayDetailRepository/PutAwayDetailRepository.dart';

class PutAwayDetailBloc extends Bloc<PutAwayDetailEvent, PutAwayDetailState> {
  final PutAwayDetailRepository putAwayDetailRepository;

  PutAwayDetailBloc({required this.putAwayDetailRepository})
    : super(PutAwayDetailInitial()) {
    on<FetchPutAwayDetail>(_fetchPutAwayDetail);
    on<UpdatePutAwayDetail>(_updatePutAwayDetail);
  }

  Future<void> _fetchPutAwayDetail(
    FetchPutAwayDetail event,
    Emitter<PutAwayDetailState> emit,
  ) async {
    emit(PutAwayDetailLoading());
    try {
      final putAwayDetail = await putAwayDetailRepository
          .getPutAwayDetailsByPutawayCode(event.putAwayCode);
      emit(
        PutAwayDetailLoaded(putAwayDetailResponseDTO: putAwayDetail.Data!.Data),
      );
    } catch (e) {
      emit(PutAwayDetailError(e.toString()));
    }
  }

  Future<void> _updatePutAwayDetail(
    UpdatePutAwayDetail event,
    Emitter<PutAwayDetailState> emit,
  ) async {
    emit(PutAwayDetailLoading());
    try {
      final putAwayDetail = await putAwayDetailRepository.updatePutAwayDetail(
        event.putAwayDetailRequestDTO,
      );
      if (putAwayDetail.Success) {
        emit(PutAwayDetailSuccess(putAwayDetail.Message));
        final putAwayDetailResponse = await putAwayDetailRepository
            .getPutAwayDetailsByPutawayCode(
              event.putAwayDetailRequestDTO.PutAwayCode,
            );
        emit(
          PutAwayDetailLoaded(
            putAwayDetailResponseDTO: putAwayDetailResponse.Data!.Data,
          ),
        );
      } else {
        emit(PutAwayDetailError(putAwayDetail.Message));
      }
    } catch (e) {
      emit(PutAwayDetailError(e.toString()));
    }
  }
}
