import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sertific8/states/input_name_states.dart';

class NameInputSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      showDragHandle: false,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      builder: (context) => const _BottomSheetNavigator(),
    );
  }
}

// Nested Navigator for bottom sheet
class _BottomSheetNavigator extends StatelessWidget {
  const _BottomSheetNavigator();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/manual':
                return const ManualInputWidget();
              case '/csv':
                return const CsvInputWidget();
              default:
                return const _InputOptionsContent();
            }
          },
        );
      },
    );
  }
}

// Main options screen
class _InputOptionsContent extends StatelessWidget {
  const _InputOptionsContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih Metode Input Data',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/manual');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Input Manual',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/csv');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Pilih File CSV',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}

// Manual input widget
class ManualInputWidget extends StatelessWidget {
  const ManualInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManualInputProvider(),
      child: Consumer<ManualInputProvider>(
        builder: (context, provider, _) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
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
                        'Input Manual',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.controllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: provider.controllers[index],
                                  focusNode: provider.focusNodes[index],
                                  decoration: InputDecoration(
                                    labelText: 'Nama ${index + 1}',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  autofocus: index == 0,
                                  onSubmitted: (_) => provider.addNewNameField(),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              if (provider.controllers.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => provider.removeNameField(index),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: provider.addNewNameField,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Nama'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      final names = provider.getNames();
                      if (names.isNotEmpty) {
                        // TODO: Process manual name inputs
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${names.length} nama tersimpan'),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text('Simpan Semua'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// CSV input widget
class CsvInputWidget extends StatelessWidget {
  const CsvInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CsvInputProvider(),
      child: Consumer<CsvInputProvider>(
        builder: (context, provider, _) => _CsvInputContent(provider: provider),
      ),
    );
  }
}

class _CsvInputContent extends StatelessWidget {
  final CsvInputProvider provider;

  const _CsvInputContent({required this.provider});

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
            if (provider.selectedFile == null)
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
                            provider.selectedFile!.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: provider.clearFile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.csvData != null) ...[
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
                            provider.csvData![0].length,
                            (index) => DataColumn(
                              label: Column(
                                children: [
                                  Text(
                                    provider.csvData![0][index].toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Radio<int>(
                                    value: index,
                                    groupValue: provider.selectedColumnIndex,
                                    onChanged: (value) => provider.setSelectedColumnIndex(value),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          rows: provider.csvData!.skip(1).take(10).map((row) {
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
                if (provider.csvData!.length > 11)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Menampilkan 10 dari ${provider.csvData!.length - 1} baris',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ],
            const SizedBox(height: 16),
            if (provider.selectedFile == null)
              FilledButton.icon(
                onPressed: () => provider.selectCsvFile(context),
                icon: const Icon(Icons.folder_open),
                label: const Text('Pilih File'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              )
            else if (provider.csvData != null) ...[
              OutlinedButton.icon(
                onPressed: () => provider.selectCsvFile(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Ganti File'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: provider.selectedColumnIndex != null
                    ? () {
                        final names = provider.getSelectedColumnData();
                        // TODO: Process CSV column data
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${names.length} nama diimpor dari CSV'),
                          ),
                        );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Proses Data'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
