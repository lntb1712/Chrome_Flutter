abstract class QRGeneratorState {}

class QRGenerating extends QRGeneratorState {}

class QRGenerated extends QRGeneratorState {
  final String message;

  QRGenerated({required this.message});
}

class QRGeneratorError extends QRGeneratorState {
  final String message;

  QRGeneratorError({required this.message});
}
