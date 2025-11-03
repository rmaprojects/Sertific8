import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sertific8/states/input_name_states.dart';

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
