import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';


class CommandScriptService {
  static String? _executablePath;

  static String _getExecutableName() {
    if (Platform.isMacOS) {
      return 'executables/macos/sertific8';
    } else if (Platform.isWindows) {
      return 'executables/windows/sertific8.exe';
    } else if (Platform.isLinux) {
      return 'executables/linux/sertific8';
    }
    throw UnsupportedError("Platform is not Supported");
  }

  static Future<String> _ensureExecutableExists() async {
    if (_executablePath != null && File(_executablePath!).existsSync()) {
      return _executablePath!;
    }

    final tempDir = await getTemporaryDirectory();
    final executableName = Platform.isWindows ? 'sertific8.exe' : 'sertific8';
    final executableFile = File('${tempDir.path}/$executableName');

    // Extract executable from assets
    final assetPath = _getExecutableName();
    final executableBytes = await rootBundle.load(assetPath);
    await executableFile.writeAsBytes(executableBytes.buffer.asUint8List());

    // Make executable on Unix systems
    if (!Platform.isWindows) {
      await Process.run('chmod', ['+x', executableFile.path]);
    }

    _executablePath = executableFile.path;
    return _executablePath!;
  }

  static Future<List<String>> processImageWithNames({
    required String imagePath,
    required int pixelX,
    required int pixelY,
    required List<String> names,
    required String outputDirectory,
  }) async {
    try {
      final executablePath = await _ensureExecutableExists();
      final shell = Shell(runInShell:  true);


      final namesStr = names.join(' ');
      final command = '"$executablePath" '
          '--names $namesStr '
          '--image "$imagePath" '
          '--output "$outputDirectory" '
          '--position $pixelX $pixelY';

      final result = await shell.run(command);

      final output = result.first.stdout.toString();
      final json = jsonDecode(output);

      return List<String>.from(json['output_paths'] ?? []);
    } catch (e) {
      throw Exception('Execution Failed: $e');
    }
  }
}