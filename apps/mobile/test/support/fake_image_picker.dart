import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// A real, valid 1x1 transparent PNG — using arbitrary bytes here would
/// let `Image.memory` fail to decode, which surfaces as an uncaught
/// FlutterError during the test rather than a clean picture.
final Uint8List kFake1x1Png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

/// A test double for [ImagePickerPlatform] that returns an in-memory
/// [XFile] instead of touching the real camera/gallery — lets widget tests
/// drive the actual photo-picking UI (tap "Take photo", etc.) rather than
/// skipping straight past it.
class FakeImagePicker extends ImagePickerPlatform {
  FakeImagePicker({Uint8List? bytes}) : _bytes = bytes ?? kFake1x1Png;

  final Uint8List _bytes;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return XFile.fromData(_bytes, name: 'mock.png', mimeType: 'image/png');
  }
}
