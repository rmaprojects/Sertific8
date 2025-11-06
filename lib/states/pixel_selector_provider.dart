import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

class PixelSelectorProvider extends ChangeNotifier {
  Offset? _selectedPixel;
  Offset? _hoverPixel;
  bool _isLocked = false;
  Size? _imageSize; // Displayed image size
  Size? _actualImageSize; // Actual file image size
  XFile? _imageFile;

  Offset? get selectedPixel => _selectedPixel;
  Offset? get hoverPixel => _hoverPixel;
  bool get isLocked => _isLocked;
  Size? get imageSize => _imageSize;
  XFile? get imageFile => _imageFile;

  // Get the actual pixel coordinates in the original image file
  Offset? get actualSelectedPixel {
    if (_selectedPixel == null || _imageSize == null || _actualImageSize == null) {
      return _selectedPixel;
    }

    // Calculate scale factor
    final scaleX = _actualImageSize!.width / _imageSize!.width;
    final scaleY = _actualImageSize!.height / _imageSize!.height;

    // Convert displayed coordinates to actual image coordinates
    return Offset(
      _selectedPixel!.dx * scaleX,
      _selectedPixel!.dy * scaleY,
    );
  }

  void setImageSize(Size size) {
    _imageSize = size;
    notifyListeners();
  }

  void setImageFile(XFile file) async {
    _imageFile = file;

    // Load the actual image dimensions
    try {
      final bytes = await File(file.path).readAsBytes();
      final image = await decodeImageFromList(bytes);
      _actualImageSize = Size(image.width.toDouble(), image.height.toDouble());
      image.dispose();
    } catch (e) {
      debugPrint('Error loading image dimensions: $e');
    }

    notifyListeners();
  }

  void updateHoverPosition(Offset position) {
    if (_isLocked) return;
    _hoverPixel = position;
    notifyListeners();
  }

  void clearHover() {
    if (_isLocked) return;
    _hoverPixel = null;
    notifyListeners();
  }

  void toggleLock(Offset? position) {
    if (_isLocked) {
      // Unlock: allow hover tracking again
      _isLocked = false;
      _selectedPixel = null;
    } else {
      // Lock: freeze the position
      _isLocked = true;
      _selectedPixel = position;
    }
    notifyListeners();
  }

  void reset() {
    _selectedPixel = null;
    _hoverPixel = null;
    _isLocked = false;
    _imageSize = null;
    _actualImageSize = null;
    _imageFile = null;
    notifyListeners();
  }
}
