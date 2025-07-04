import '../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderRequestDTO.dart';

abstract class ManufacturingOrderEvent {}

class FetchManufacturingOrderEvent extends ManufacturingOrderEvent {
  final int page;

  FetchManufacturingOrderEvent({required this.page});
}

class FetchManufacturingOrderFilteredEvent extends ManufacturingOrderEvent {
  final String textToSearch;
  final int page;

  FetchManufacturingOrderFilteredEvent({
    required this.textToSearch,
    required this.page,
  });
}

class UpdateManufacturingOrderEvent extends ManufacturingOrderEvent {
  final ManufacturingOrderRequestDTO manufacturingOrderRequestDTO;

  UpdateManufacturingOrderEvent({required this.manufacturingOrderRequestDTO});
}
