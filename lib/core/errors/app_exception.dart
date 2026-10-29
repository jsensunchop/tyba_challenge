/// The only error type the presentation layer should ever see.
class AppException implements Exception {
  const AppException(this.message);

  /// User-facing message, in Spanish.
  final String message;

  @override
  String toString() => 'AppException: $message';
}
