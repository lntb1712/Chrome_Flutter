import 'package:chrome_flutter/Blocs/MovementDetailBloc/MovementDetailEvent.dart';
import 'package:chrome_flutter/Blocs/MovementDetailBloc/MovementDetailState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/MovementDetailRepository/MovementDetailRepository.dart';

class MovementDetailBloc
    extends Bloc<MovementDetailEvent, MovementDetailState> {
  final MovementDetailRepository movementDetailRepository;

  MovementDetailBloc({required this.movementDetailRepository})
    : super(MovementDetailInitial()) {
    on<FetchMovementDetailEvent>(_fetchMovementDetail);
  }

  Future<void> _fetchMovementDetail(
    FetchMovementDetailEvent event,
    Emitter<MovementDetailState> emit,
  ) async {
    emit(MovementDetailLoading());
    try {
      final movements =
          await movementDetailRepository.GetMovementDetailsByMovementCode(
            event.movementCode,
          );
      emit(MovementDetailLoaded(movements: movements.Data!.Data));
    } catch (e) {
      emit(MovementDetailError(message: e.toString()));
    }
  }
}
