import 'dart:io';
import 'package:flutter/material.dart';

class ResultsProvider extends ChangeNotifier {
  List<String> _imagePaths = [];
  Set<int> _selectedIndices = {};

  List<String> get imagePaths => _imagePaths;
  Set<int> get selectedIndices => _selectedIndices;
  bool get allSelected => _selectedIndices.length == _imagePaths.length && _imagePaths.isNotEmpty;
  bool get hasSelection => _selectedIndices.isNotEmpty;
  int get selectedCount => _selectedIndices.length;

  List<String> get selectedPaths {
    return _selectedIndices
        .map((index) => _imagePaths[index])
        .toList();
  }  void setImagePaths(List<String> paths) {
    _imagePaths = paths;
    // Select all by default
    _selectedIndices = Set.from(List.generate(_imagePaths.length, (index) => index));
    notifyListeners();
  }

  void toggleSelection(int index) {
    if (_selectedIndices.contains(index)) {
      _selectedIndices.remove(index);
    } else {
      _selectedIndices.add(index);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedIndices = Set.from(List.generate(_imagePaths.length, (index) => index));
    notifyListeners();
  }

  void deselectAll() {
    _selectedIndices.clear();
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    final pathsToDelete = _selectedIndices
        .map((index) => _imagePaths[index])
        .toList();

    for (final path in pathsToDelete) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Error deleting file $path: $e');
      }
    }

    // Remove deleted paths from the list
    _imagePaths.removeWhere((path) => pathsToDelete.contains(path));
    _selectedIndices.clear();
    notifyListeners();
  }

  void reset() {
    _imagePaths = [];
    _selectedIndices.clear();
    notifyListeners();
  }
}
