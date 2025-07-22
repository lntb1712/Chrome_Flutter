abstract class QRScanEvent {}

class LoadInitialData extends QRScanEvent {}

class ScanQrSuccess extends QRScanEvent {
  final String qrData;

  ScanQrSuccess(this.qrData);
}
