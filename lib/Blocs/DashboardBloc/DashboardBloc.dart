import 'package:chrome_flutter/Blocs/DashboardBloc/DashboardEvent.dart';
import 'package:chrome_flutter/Blocs/DashboardBloc/DashboardState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/DashboardRepository/DashboardRepository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc(this.dashboardRepository) : super(DashboardInitial()) {
    on<FetchDashboardHandyAsync>(_onFetchDashboardHandyAsync);
  }

  Future<void> _onFetchDashboardHandyAsync(
    FetchDashboardHandyAsync event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final response = await dashboardRepository.GetDashboardHandyAsync(
        event.handyDashboardRequestDTO,
      );
      emit(DashboardLoaded(handyDashboardResponseDTO: response.Data!));
    } catch (e) {
      emit(DashboardError(error: e.toString()));
    }
  }
}
