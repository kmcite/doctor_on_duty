import 'dart:convert';

import 'package:doctor_on_duty/domain/api/import_export_repository.dart';
import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/dark.dart';
import 'package:doctor_on_duty/ui/ui.dart';
import 'package:forui/forui.dart';

Map<String, dynamic> json = {};

void setState(VoidCallback fn) {}

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Settings'),
        suffixes: [
          FHeaderAction.x(
            onPress: () => apply(NavigateBack()),
          ),
        ],
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTile(
            prefix: Icon(
              state.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            title: Text(state.dark ? 'Dark Mode' : 'Light Mode'),
            suffix: FSwitch(
              value: state.dark,
              onChange: (_) => apply(ToggleDarkMode()),
            ),
          ),
          FTile(
            prefix: const Icon(Icons.import_export),
            title: const Text('Import/Export'),
            subtitle: const Text('Backup and restore your data'),
            onPress: () async {
              apply(
                ShowDialog(
                  (_, _, _) => const ImportExportDialog(),
                ),
              );
            },
          ),
          if (json.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Imported Data:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final key in json.entries)
                          ActionChip(
                            label: Text(key.key),
                            onPressed: () {
                              apply(
                                ShowDialog(
                                  (_, _, _) => AlertDialog(
                                    title: const Text('Data Details'),
                                    content: Text(
                                      'Key: ${key.key}\nValue: ${key.value}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => apply(NavigateBack()),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum OperationStatus {
  importing,
  exporting,
  idle,
  files,
}

OperationStatus status = OperationStatus.idle;

class ImportExportDialog extends UI {
  const ImportExportDialog({super.key});

  Future<void> _exportAllData() async {
    final data = <String, dynamic>{};

    // Export cases
    final casesList = store.state.patients.patients;
    data['cases'] = casesList.map((c) => c.toJson()).toList();

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    await exportInAppData(jsonString);
  }

  Future<Map<String, dynamic>?> _importData() async {
    final json = await importFromFileSystem();

    if (json == null) return null;

    // Validate imported data
    if (!validateImportedData(json)) {
      throw Exception('Invalid data format or structure');
    }

    return json;
  }

  void _showSuccessMessage(String message) {
    apply(
      ShowDialog(
        (_, _, _) => AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => apply(NavigateBack()),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    apply(
      ShowDialog(
        (_, _, _) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => apply(NavigateBack()),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import/Export Data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Backup your medical data or restore from a previous backup',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),

            // Export section
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.upload,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Export Data',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a backup of all your data including symptoms, diagnoses, topics, and cases.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: status == OperationStatus.exporting
                                  ? null
                                  : () async {
                                      status = OperationStatus.exporting;
                                      try {
                                        await _exportAllData();
                                        apply(NavigateBack());
                                        _showSuccessMessage(
                                          'Data exported successfully',
                                        );
                                      } catch (e) {
                                        _showErrorMessage('Export failed: $e');
                                      } finally {
                                        status = OperationStatus.idle;
                                      }
                                    },
                              icon: status == OperationStatus.exporting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_download),
                              label: const Text('Export All Data'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Import section
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.download,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Import Data',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Restore data from a previous backup file. This will add to your existing data.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: status == OperationStatus.importing
                                  ? null
                                  : () async {
                                      status = OperationStatus.importing;
                                      try {
                                        final result = await _importData();
                                        status = OperationStatus.idle;
                                        if (result != null) {
                                          apply(NavigateBack());
                                        }
                                      } catch (e) {
                                        status = OperationStatus.idle;
                                        _showErrorMessage('Import failed: $e');
                                      }
                                    },
                              icon: status == OperationStatus.importing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_upload),
                              label: const Text('Import from File'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Cancel button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => apply(NavigateBack()),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
