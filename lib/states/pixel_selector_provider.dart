import 'package:flutter/material.dart';

class PixelSelectorProvider extends ChangeNotifier {
  Offset? _selectedPixel;
  Offset? _hoverPixel;
  bool _isLocked = false;
  Size? _imageSize;

  Offset? get selectedPixel => _selectedPixel;
  Offset? get hoverPixel => _hoverPixel;
  bool get isLocked => _isLocked;
  Size? get imageSize => _imageSize;

  void setImageSize(Size size) {
    _imageSize = size;
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
    notifyListeners();
  }
}
