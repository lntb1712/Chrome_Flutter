
import 'package:flutter_bloc/flutter_bloc.dart';

import 'QRScanEvent.dart';
import 'QRScanState.dart';


class QRScanBloc extends Bloc<QRScanEvent, QRScanState> {
  QRScanBloc() : super(QRScanLoading()) {
    on<LoadInitialData>((event, emit) {
      emit(QRScanLoaded(qrData: null));
    });

    on<ScanQrSuccess>((event, emit) {
      emit(QRScanLoaded(qrData: event.qrData));
    });
  }
}
