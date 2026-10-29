import 'package:tyba_universities/core/services/image_picker_service.dart';

class FakeImagePickerService implements ImagePickerService {
  FakeImagePickerService({this.path, this.error});

  /// Returned by both pick methods; null simulates the user cancelling.
  final String? path;

  /// When set, both pick methods throw it.
  final Exception? error;

  @override
  Future<String?> pickFromCamera() => _pick();

  @override
  Future<String?> pickFromGallery() => _pick();

  Future<String?> _pick() async {
    if (error != null) throw error!;
    return path;
  }
}
