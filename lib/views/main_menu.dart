import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:go_router/go_router.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  Future<void> _pickFile(BuildContext context) async {

    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Images',
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup], confirmButtonText: "Pilih file ini");

    if (file == null || !context.mounted) return;

    context.push('/pixel_selector', extra: file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sertific8', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 10),
              const Text('Aplikasi Pengisi Sertifikat Otomatis'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _pickFile(context),
                child: const Text('Pilih File')
              ),
            ],
          ),
      ),
    );
  }
}