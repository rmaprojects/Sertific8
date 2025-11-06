import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sertific8/states/input_name_states.dart';
import 'package:sertific8/states/pixel_selector_provider.dart';
import 'package:sertific8/states/output_state.dart';

// CSV input widget
class CsvInputWidget extends StatelessWidget {

  final PixelSelectorProvider pixelProvider;
  final GlobalOutputStateProvider confirmationProvider;

  const CsvInputWidget({super.key, required this.pixelProvider, required this.confirmationProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CsvInputProvider(),
      child: Consumer<CsvInputProvider>(
        builder: (context, provider, _) => _CsvInputContent(csvInputProvider: provider, pixelProvider: pixelProvider, confirmationProvider: confirmationProvider),
      ),
    );
  }
}

class _CsvInputContent extends StatelessWidget {
  final CsvInputProvider csvInputProvider;
  final PixelSelectorProvider pixelProvider;
  final GlobalOutputStateProvider confirmationProvider;

  const _CsvInputContent({required this.csvInputProvider, required this.pixelProvider, required this.confirmationProvider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Import dari CSV',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (csvInputProvider.selectedFile == null)
              Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada file dipilih',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih file CSV yang berisi daftar nama',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File terpilih:',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            csvInputProvider.selectedFile!.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: csvInputProvider.clearFile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (csvInputProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (csvInputProvider.csvData != null) ...[
                Text(
                  'Pilih kolom yang berisi nama:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: List.generate(
                            csvInputProvider.csvData![0].length,
                            (index) => DataColumn(
                              label: Column(
                                children: [
                                  Text(
                                    csvInputProvider.csvData![0][index].toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  RadioGroup<int>(
                                    groupValue: csvInputProvider.selectedColumnIndex,
                                    onChanged: (value) => csvInputProvider.setSelectedColumnIndex(value),
                                    child: Radio<int>(value: index)
                                  )
                                  // Radio<int>(
                                  //   value: index,
                                  //   groupValue: provider.selectedColumnIndex,
                                  //   onChanged: (value) => provider.setSelectedColumnIndex(value),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          rows: csvInputProvider.csvData!.skip(1).take(10).map((row) {
                            return DataRow(
                              cells: List.generate(
                                row.length,
                                (index) => DataCell(
                                  Text(row[index].toString()),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                if (csvInputProvider.csvData!.length > 11)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Menampilkan 10 dari ${csvInputProvider.csvData!.length - 1} baris',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ],
            const SizedBox(height: 16),
            if (csvInputProvider.selectedFile == null)
              FilledButton.icon(
                onPressed: () => csvInputProvider.selectCsvFile(context),
                icon: const Icon(Icons.folder_open),
                label: const Text('Pilih File'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              )
            else if (csvInputProvider.csvData != null) ...[
              OutlinedButton.icon(
                onPressed: () => csvInputProvider.selectCsvFile(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Ganti File'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: csvInputProvider.selectedColumnIndex != null
                    ? () {
                        final names = csvInputProvider.getSelectedColumnData();
                        // Navigate to confirmation screen
                        Navigator.of(context, rootNavigator: true).pop();

                        confirmationProvider.setData(
                          names: names,
                          imagePath: pixelProvider.imageFile?.path ?? '',
                          pixelPosition: pixelProvider.actualSelectedPixel ?? Offset.zero,
                        );

                        context.push('/confirmation');
                      }
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Lanjut ke Konfirmasi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
