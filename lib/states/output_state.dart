import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

class GlobalOutputStateProvider extends ChangeNotifier {
  List<String> _names = [];
  String? _imagePath;
  Offset? _pixelPosition;
  String? _outputDirectory;
  bool _isProcessing = false;

  List<String> get names => _names;
  String? get imagePath => _imagePath;
  Offset? get pixelPosition => _pixelPosition;
  String? get outputDirectory => _outputDirectory;
  bool get isProcessing => _isProcessing;

  void setData({
    required List<String> names,
    required String imagePath,
    required Offset pixelPosition,
  }) {
    _names = names;
    _imagePath = imagePath;
    _pixelPosition = pixelPosition;
    notifyListeners();
  }

  Future<void> selectOutputDirectory() async {
    try {
      final directory = await getDirectoryPath();
      if (directory != null) {
        _outputDirectory = directory;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to select directory: $e');
    }
  }

  void clearOutputDirectory() {
    _outputDirectory = null;
    notifyListeners();
  }

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void reset() {
    _names = [];
    _imagePath = null;
    _pixelPosition = null;
    _outputDirectory = null;
    _isProcessing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
