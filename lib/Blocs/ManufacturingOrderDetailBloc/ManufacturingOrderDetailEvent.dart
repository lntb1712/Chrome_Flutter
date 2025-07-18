import '../../Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailRequestDTO.dart';

abstract class ManufacturingOrderDetailEvent {}

class FetchManufacturingOrderDetailEvent extends ManufacturingOrderDetailEvent {
  final String manufacturingOrderCode;

  FetchManufacturingOrderDetailEvent({required this.manufacturingOrderCode});
}

class UpdateManufacturingOrderDetailEvent
    extends ManufacturingOrderDetailEvent {
  final List<ManufacturingOrderDetailRequestDTO>
  manufacturingOrderDetailRequestDTO;

  UpdateManufacturingOrderDetailEvent({
    required this.manufacturingOrderDetailRequestDTO,
  });
}
