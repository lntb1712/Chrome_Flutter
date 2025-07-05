import 'package:chrome_flutter/Blocs/ManufacturingOrderBloc/ManufacturingOrderEvent.dart';
import 'package:chrome_flutter/Blocs/ManufacturingOrderBloc/ManufacturingOrderState.dart';
import 'package:chrome_flutter/Data/Repositories/ManufacturingOrderRepository/ManufacturingOrderRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManufacturingOrderBloc
    extends Bloc<ManufacturingOrderEvent, ManufacturingOrderState> {
  final ManufacturingOrderRepository manufacturingOrderRepository;

  ManufacturingOrderBloc({required this.manufacturingOrderRepository})
    : super(ManufacturingOrderInitial()) {
    on<FetchManufacturingOrderEvent>(_fetchManufacturingOrders);
    on<FetchManufacturingOrderFilteredEvent>(_fetchManufacturingOrdersFiltered);
    on<UpdateManufacturingOrderEvent>(_updateManufacturingOrder);
  }

  Future<void> _fetchManufacturingOrders(
    FetchManufacturingOrderEvent event,
    Emitter<ManufacturingOrderState> emit,
  ) async {
    emit(ManufacturingOrderLoading());
    try {
      final manufacturingOrders =
          await manufacturingOrderRepository.GetAllManufacturingOrdersAsyncWithResponsible(
            event.page,
          );
      emit(
        ManufacturingOrderLoaded(
          ManufacturingOrders: manufacturingOrders.Data!,
        ),
      );
    } catch (e) {
      emit(ManufacturingOrderError(message: e.toString()));
    }
  }

  Future<void> _fetchManufacturingOrdersFiltered(
    FetchManufacturingOrderFilteredEvent event,
    Emitter<ManufacturingOrderState> emit,
  ) async {
    emit(ManufacturingOrderLoading());
    try {
      final manufacturingOrders =
          await manufacturingOrderRepository.GetAllManufacturingOrdersAsyncWithResponsible(
            event.page,
          );
      emit(
        ManufacturingOrderLoaded(
          ManufacturingOrders: manufacturingOrders.Data!,
        ),
      );
    } catch (e) {
      emit(ManufacturingOrderError(message: e.toString()));
    }
  }

  Future<void> _updateManufacturingOrder(
    UpdateManufacturingOrderEvent event,
    Emitter<ManufacturingOrderState> emit,
  ) async {
    emit(ManufacturingOrderLoading());
    try {
      final updatedManufacturingOrder =
          await manufacturingOrderRepository.UpdateManufacturingOrder(
            event.manufacturingOrderRequestDTO,
          );
      emit(
        ManufacturingOrderSuccess(message: updatedManufacturingOrder.Message),
      );
      final manufacturingOrders =
          await manufacturingOrderRepository.GetAllManufacturingOrdersAsyncWithResponsible(
            1,
          );
      emit(
        ManufacturingOrderLoaded(
          ManufacturingOrders: manufacturingOrders.Data!,
        ),
      );
    } catch (e) {
      emit(ManufacturingOrderError(message: e.toString()));
    }
  }
}
