import 'package:chrome_flutter/Blocs/MovementBloc/MovementEvent.dart';
import 'package:chrome_flutter/Blocs/MovementBloc/MovementState.dart';
import 'package:chrome_flutter/Data/Repositories/MovementRepository/MovementRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovementBloc extends Bloc<MovementEvent, MovementState> {
  final MovementRepository movementRepository;

  MovementBloc({required this.movementRepository}) : super(MovementInitial()) {
    on<FetchMovementEvent>(_fetchMovement);
    on<FetchMovementFilteredEvent>(_fetchMovementFiltered);
  }

  Future<void> _fetchMovement(
    FetchMovementEvent event,
    Emitter<MovementState> emit,
  ) async {
    emit(MovementLoading());
    try {
      final movements = await movementRepository.GetAllMovementsWithResponsible(
        event.page,
      );
      emit(MovementLoaded(movements: movements.Data!));
    } catch (e) {
      emit(MovementError(message: e.toString()));
    }
  }

  Future<void> _fetchMovementFiltered(
    FetchMovementFilteredEvent event,
    Emitter<MovementState> emit,
  ) async {
    emit(MovementLoading());
    try {
      final movements = await movementRepository.SearchMovementsWithResponsible(
        event.textToSearch,
        event.page,
      );
      emit(MovementLoaded(movements: movements.Data!));
    } catch (e) {
      emit(MovementError(message: e.toString()));
    }
  }
}
