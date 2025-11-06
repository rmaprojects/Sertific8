import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sertific8/services/cmd_script_service.dart';
import 'package:sertific8/states/output_state.dart';
import 'package:sertific8/states/results_provider.dart';

class ConfirmationMenu extends StatelessWidget {
  const ConfirmationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalOutputStateProvider>(
      builder: (context, provider, _) =>
          _ConfirmationContent(provider: provider),
    );
  }
}

class _ConfirmationContent extends StatelessWidget {
  final GlobalOutputStateProvider provider;

  const _ConfirmationContent({required this.provider});

  Future<void> _executeGenerateSertificate(BuildContext context) async {
    if (provider.outputDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih folder output terlebih dahulu'),
        ),
      );
      return;
    }

    try {
      provider.setProcessing(true);

      final outputPaths = await CommandScriptService.processImageWithNames(
        imagePath: provider.imagePath!,
        pixelX: provider.pixelPosition!.dx.toInt(),
        pixelY: provider.pixelPosition!.dy.toInt(),
        names: provider.names,
        outputDirectory: provider.outputDirectory!,
      );

      provider.setProcessing(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil membuat ${outputPaths.length} sertifikat!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // Set result paths and navigate to results screen
        final resultsProvider = context.read<ResultsProvider>();
        resultsProvider.setImagePaths(outputPaths);

        context.push('/results');
      }
    } catch (e) {
      provider.setProcessing(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memproses: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Names List Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Daftar Nama',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: provider.names.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(
                                '${index + 1}.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  provider.names[index],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${provider.names.length} nama',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Image Info Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Template Sertifikat',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (provider.imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(provider.imagePath!),
                          fit: BoxFit.contain,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      provider.imagePath?.split('/').last ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pixel Position Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Posisi Teks',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'X: ${provider.pixelPosition?.dx.toInt() ?? 0}, Y: ${provider.pixelPosition?.dy.toInt() ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Output Directory Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.folder,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Folder Output',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (provider.outputDirectory == null)
                      Text(
                        'Belum dipilih',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              provider.outputDirectory!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: provider.clearOutputDirectory,
                            tooltip: 'Hapus pilihan',
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: provider.selectOutputDirectory,
                      icon: Icon(
                        provider.outputDirectory == null
                            ? Icons.folder_open
                            : Icons.refresh,
                      ),
                      label: Text(
                        provider.outputDirectory == null
                            ? 'Pilih Folder'
                            : 'Ganti Folder',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Confirmation Button
            FilledButton(
              onPressed: provider.isProcessing
                  ? null
                  : () async {
                      // Show modal bottom sheet with loading
                      showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        enableDrag: false,
                        backgroundColor: Colors.transparent,
                        builder: (bottomSheetContext) => PopScope(
                          canPop: false,
                          child: SizedBox(
                            height: double.infinity,
                            child: Center(
                              child: Card(
                                margin: const EdgeInsets.all(32),
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Memproses sertifikat, mohon tunggu...',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                      await _executeGenerateSertificate(context);

                      // Dismiss bottom sheet after processing
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(20)),
              child: provider.isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Proses & Buat Sertifikat',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: provider.isProcessing
                  ? null
                  : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
