import '../../Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailResponseDTO.dart';

abstract class ManufacturingOrderDetailState {}

class ManufacturingOrderDetailInitial extends ManufacturingOrderDetailState {}

class ManufacturingOrderDetailLoading extends ManufacturingOrderDetailState {}

class ManufacturingOrderDetailLoaded extends ManufacturingOrderDetailState {
  final List<ManufacturingOrderDetailResponseDTO>
  manufacturingOrderDetailResponseDTO;

  ManufacturingOrderDetailLoaded({
    required this.manufacturingOrderDetailResponseDTO,
  });
}

class ManufacturingOrderDetailErorr extends ManufacturingOrderDetailState {
  final String message;

  ManufacturingOrderDetailErorr({required this.message});
}

class ManufacturingOrderDetailSuccess extends ManufacturingOrderDetailState {
  final String message;

  ManufacturingOrderDetailSuccess({required this.message});
}
