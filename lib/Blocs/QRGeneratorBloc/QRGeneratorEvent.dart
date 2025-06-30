import '../../Data/Models/QRGeneratorDTO/QRGeneratorRequestDTO.dart';

abstract class QRGeneratorEvent {}

class QRGenerateEvent extends QRGeneratorEvent {
  final QRGeneratorRequestDTO qrGeneratorRequestDTO;

  QRGenerateEvent({required this.qrGeneratorRequestDTO});
}
