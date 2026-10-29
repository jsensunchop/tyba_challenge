import 'package:image_picker/image_picker.dart';

/// Thin wrapper over `image_picker`. It exists so tests can swap it for a
/// fake through a provider, since the plugin needs a real platform.
class ImagePickerService {
  final _picker = ImagePicker();

  /// Returns the image path, or null if the user cancels.
  Future<String?> pickFromCamera() => _pick(ImageSource.camera);

  /// Returns the image path, or null if the user cancels.
  Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<String?> _pick(ImageSource source) async {
    // Downscaled so a full-resolution photo doesn't sit in memory.
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    return file?.path;
  }
}
