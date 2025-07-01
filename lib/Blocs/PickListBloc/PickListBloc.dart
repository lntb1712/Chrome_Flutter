import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/PickListRepository/PickListRepository.dart';
import 'PickListEvent.dart';
import 'PickListState.dart';

class PickListBloc extends Bloc<PickListEvent, PickListState> {
  final PickListRepository pickListRepository;

  PickListBloc({required this.pickListRepository}) : super(PickListInitial()) {
    on<FetchPickListEvent>(_fetchPickList);
    on<FetchPickListFilteredEvent>(_fetchPickListFiltered);
    on<FetchPickAndDetailEvent>(_fetchPickAndDetail);
  }

  Future<void> _fetchPickList(
    FetchPickListEvent event,
    Emitter<PickListState> emit,
  ) async {
    emit(PickListLoading());

    try {
      final pickList =
          await pickListRepository.GetAllPickListsAsyncWithResponsible();
      emit(PickListLoaded(pickLists: pickList.Data!.Data));
    } catch (e) {
      emit(PickListError(message: e.toString()));
    }
  }

  Future<void> _fetchPickListFiltered(
    FetchPickListFilteredEvent event,
    Emitter<PickListState> emit,
  ) async {
    emit(PickListLoading());
    try {
      final pickList =
          await pickListRepository.SearchPickListsAsyncWithResponsible(
            event.textToSearch,
          );
      emit(PickListLoaded(pickLists: pickList.Data!.Data));
    } catch (e) {
      emit(PickListError(message: e.toString()));
    }
  }

  Future<void> _fetchPickAndDetail(
    FetchPickAndDetailEvent event,
    Emitter<PickListState> emit,
  ) async {
    emit(PickListLoading());
    try {
      final pickAndDetail =
          await pickListRepository.GetPickListContainCodeAsync(event.orderCode);
      emit(PickLoaded(pickLists: pickAndDetail.Data!));
    } catch (e) {
      emit(PickListError(message: e.toString()));
    }
  }
}
