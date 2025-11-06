import 'package:flutter/material.dart';
import 'package:sertific8/states/output_state.dart';
import 'package:sertific8/states/pixel_selector_provider.dart';
import 'package:sertific8/views/name_input_sheet/csv/csv_input.dart';
import 'package:sertific8/views/name_input_sheet/manual/manual_form_input.dart';

class NameInputSheet {
  static void show(BuildContext context, {required PixelSelectorProvider pixelProvider, required GlobalOutputStateProvider confirmationProvider}) {
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
      builder: (context) => _BottomSheetNavigator(pixelProvider: pixelProvider, confirmationProvider: confirmationProvider),
    );
  }
}

// Nested Navigator for bottom sheet
class _BottomSheetNavigator extends StatelessWidget {
  final PixelSelectorProvider pixelProvider;
  final GlobalOutputStateProvider confirmationProvider;

  const _BottomSheetNavigator({required this.pixelProvider, required this.confirmationProvider});

  @override
  Widget build(BuildContext context) {

    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/manual':
                return ManualInputWidget(pixelProvider: pixelProvider, confirmationProvider: confirmationProvider);
              case '/csv':
                return CsvInputWidget(pixelProvider: pixelProvider, confirmationProvider: confirmationProvider);
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
