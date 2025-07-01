import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/PickListDetailRepository/PickListDetailRepository.dart';
import 'PickListDetailEvent.dart';
import 'PickListDetailState.dart';

class PickListDetailBloc
    extends Bloc<PickListDetailEvent, PickListDetailState> {
  final PickListDetailRepository pickListDetailRepository;

  PickListDetailBloc({required this.pickListDetailRepository})
    : super(PickListDetailInitial()) {
    on<FetchPickListDetailEvent>(_fetchPickListDetail);
    on<UpdatePickListDetailEvent>(_updatePickListDetail);
  }

  Future<void> _fetchPickListDetail(
    FetchPickListDetailEvent event,
    Emitter<PickListDetailState> emit,
  ) async {
    emit(PickListDetailLoading());
    try {
      final pickListDetail =
          await pickListDetailRepository.GetPickListDetailsByPickNo(
            event.pickNo,
          );
      emit(PickListDetailLoaded(pickListDetails: pickListDetail.Data!.Data));
    } catch (e) {
      emit(PickListDetailError(message: e.toString()));
    }
  }

  Future<void> _updatePickListDetail(
    UpdatePickListDetailEvent event,
    Emitter<PickListDetailState> emit,
  ) async {
    emit(PickListDetailLoading());
    try {
      final pickListDetail =
          await pickListDetailRepository.UpdatePickListDetail(
            event.pickListDetailRequestDTO,
          );

      if (pickListDetail.Success!) {
        emit(PickListDetailSuccess(message: pickListDetail.Message!));
        final pickListDetailResponse =
            await pickListDetailRepository.GetPickListDetailsByPickNo(
              event.pickListDetailRequestDTO.PickNo,
            );
        emit(
          PickListDetailLoaded(
            pickListDetails: pickListDetailResponse.Data!.Data,
          ),
        );
      } else {
        emit(PickListDetailError(message: pickListDetail.Message!));
      }
    } catch (e) {
      emit(PickListDetailError(message: e.toString()));
    }
  }
}
