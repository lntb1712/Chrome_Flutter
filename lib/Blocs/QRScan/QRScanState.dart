
abstract class QRScanState {}
class QRScanLoading extends QRScanState {}

class QRScanLoaded extends QRScanState {
  final String? qrData;

  QRScanLoaded({this.qrData});


}
