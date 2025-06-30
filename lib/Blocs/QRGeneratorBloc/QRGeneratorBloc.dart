import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/QRGeneratorRepository/QRGeneratorRepository.dart';
import 'QRGeneratorEvent.dart';
import 'QRGeneratorState.dart';

class QRGeneratorBloc extends Bloc<QRGeneratorEvent, QRGeneratorState> {
  final QRGeneratorRepository qrGeneratorRepository;

  QRGeneratorBloc({required this.qrGeneratorRepository})
    : super(QRGenerating()) {
    on<QRGenerateEvent>(_generateQR);
  }

  Future<void> _generateQR(
    QRGenerateEvent event,
    Emitter<QRGeneratorState> emit,
  ) async {
    emit(QRGenerating());
    try {
      final qrGeneratorResponseDTO =
          await qrGeneratorRepository.GeneratorQRCode(
            event.qrGeneratorRequestDTO,
          );
      emit(QRGenerated(message: qrGeneratorResponseDTO.Data!.Message));
    } catch (e) {
      emit(QRGeneratorError(message: e.toString()));
    }
  }
}
