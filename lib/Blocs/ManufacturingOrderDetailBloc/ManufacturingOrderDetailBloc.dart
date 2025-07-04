import 'package:chrome_flutter/Blocs/ManufacturingOrderDetailBloc/ManufacturingOrderDetailEvent.dart';
import 'package:chrome_flutter/Blocs/ManufacturingOrderDetailBloc/ManufacturingOrderDetailState.dart';
import 'package:chrome_flutter/Data/Repositories/ManufacturingOrderDetailRepository/ManufacturingOrderDetailRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManufacturingOrderDetailBloc
    extends Bloc<ManufacturingOrderDetailEvent, ManufacturingOrderDetailState> {
  final ManufacturingOrderDetailRepository manufacturingOrderDetailRepository;

  ManufacturingOrderDetailBloc({
    required this.manufacturingOrderDetailRepository,
  }) : super(ManufacturingOrderDetailInitial()) {
    on<FetchManufacturingOrderDetailEvent>(_fetchManufacturingOrders);
  }

  Future<void> _fetchManufacturingOrders(
    FetchManufacturingOrderDetailEvent event,
    Emitter<ManufacturingOrderDetailState> emit,
  ) async {
    emit(ManufacturingOrderDetailLoading());
    try {
      final manufacturingOrders =
          await manufacturingOrderDetailRepository.GetManufacturingOrderDetails(
            event.manufacturingOrderCode,
          );
      emit(
        ManufacturingOrderDetailLoaded(
          manufacturingOrderDetailResponseDTO: manufacturingOrders.Data!.Data,
        ),
      );
    } catch (e) {
      emit(ManufacturingOrderDetailErorr(message: e.toString()));
    }
  }
}
