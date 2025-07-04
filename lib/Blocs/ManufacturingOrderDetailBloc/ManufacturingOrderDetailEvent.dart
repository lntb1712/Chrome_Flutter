abstract class ManufacturingOrderDetailEvent {}

class FetchManufacturingOrderDetailEvent extends ManufacturingOrderDetailEvent {
  final String manufacturingOrderCode;

  FetchManufacturingOrderDetailEvent({required this.manufacturingOrderCode});
}
