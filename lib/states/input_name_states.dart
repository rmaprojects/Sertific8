import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:csv/csv.dart';

// Provider for Manual Input
class ManualInputProvider extends ChangeNotifier {
  final List<TextEditingController> _controllers = [TextEditingController()];
  final List<FocusNode> _focusNodes = [FocusNode()];

  List<TextEditingController> get controllers => _controllers;
  List<FocusNode> get focusNodes => _focusNodes;

  void addNewNameField() {
    _controllers.add(TextEditingController());
    _focusNodes.add(FocusNode());
    notifyListeners();

    // Focus on the new field after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.last.requestFocus();
    });
  }

  void removeNameField(int index) {
    if (_controllers.length > 1) {
      _controllers[index].dispose();
      _focusNodes[index].dispose();
      _controllers.removeAt(index);
      _focusNodes.removeAt(index);
      notifyListeners();
    }
  }

  List<String> getNames() {
    return _controllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

// Provider for CSV Input
class CsvInputProvider extends ChangeNotifier {
  XFile? _selectedFile;
  List<List<dynamic>>? _csvData;
  int? _selectedColumnIndex;
  bool _isLoading = false;

  XFile? get selectedFile => _selectedFile;
  List<List<dynamic>>? get csvData => _csvData;
  int? get selectedColumnIndex => _selectedColumnIndex;
  bool get isLoading => _isLoading;

  void setSelectedColumnIndex(int? index) {
    _selectedColumnIndex = index;
    notifyListeners();
  }

  Future<void> selectCsvFile(BuildContext context) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'CSV Files',
      extensions: ['csv'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: [typeGroup],
      confirmButtonText: 'Pilih File CSV',
    );

    if (file != null) {
      _selectedFile = file;
      _isLoading = true;
      _csvData = null;
      _selectedColumnIndex = null;
      notifyListeners();

      try {
        final content = await file.readAsString();

        // Detect delimiter (comma or semicolon)
        final delimiter = content.contains(';') && !content.contains(',') ? ';' : ',';

        final List<List<dynamic>> rows = CsvToListConverter(
          fieldDelimiter: delimiter,
          eol: '\n',
        ).convert(content);

        _csvData = rows;
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error membaca file: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  void clearFile() {
    _selectedFile = null;
    _csvData = null;
    _selectedColumnIndex = null;
    notifyListeners();
  }

  List<String> getSelectedColumnData() {
    if (_csvData == null || _selectedColumnIndex == null) return [];

    return _csvData!
        .skip(1) // Skip header row
        .map((row) {
          if (_selectedColumnIndex! < row.length) {
            return row[_selectedColumnIndex!].toString().trim();
          }
          return '';
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
