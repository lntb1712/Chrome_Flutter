import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';

import '../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';

abstract class ManufacturingOrderState {}

class ManufacturingOrderInitial extends ManufacturingOrderState {}

class ManufacturingOrderLoading extends ManufacturingOrderState {}

class ManufacturingOrderLoaded extends ManufacturingOrderState {
  final PagedResponse<ManufacturingOrderResponseDTO> ManufacturingOrders;

  ManufacturingOrderLoaded({required this.ManufacturingOrders});
}

class ManufacturingOrderSuccess extends ManufacturingOrderState {
  final String message;

  ManufacturingOrderSuccess({required this.message});
}

class ManufacturingOrderError extends ManufacturingOrderState {
  final String message;

  ManufacturingOrderError({required this.message});
}
