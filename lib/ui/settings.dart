import 'dart:convert';

import 'package:doctor_on_duty/domain/api/picker.dart';
import 'package:doctor_on_duty/domain/api/settings_repository.dart';
import 'package:doctor_on_duty/main.dart';

import '../domain/api/navigator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsRepository settingsRepository = watch();
  void toggleDark() {
    settingsRepository.toggleDarkness();
  }

  Map<String, dynamic> json = {};

  bool get dark => settingsRepository.dark;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Settings'.text(),
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.x),
            onPress: navigator.back,
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        children: [
          FButton(
            child: Icon(
              dark ? FIcons.moon : FIcons.sun,
              size: 50,
            ),
            onPress: () => toggleDark(),
          ),
          FButton(
            onPress: () async {
              final result = await navigator
                  .dialog<Map<String, dynamic>>(ImportExportDialog());
              if (result == null) return;
              json = result;
              rebuild();
            },
            prefix: Icon(Icons.import_export),
            child: 'Import/Export'.text(),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in json.entries)
                FTappable(
                  child: FBadge(
                    child: Text(key.key),
                  ),
                  onPress: () => navigator.dialog(
                    FDialog(
                      actions: [
                        FButton(
                          onPress: () {},
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                )
            ],
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

class ImportExportDialog extends StatefulWidget {
  const ImportExportDialog({super.key});
  @override
  State<ImportExportDialog> createState() => _ImportExportDialogState();
}

class _ImportExportDialogState extends State<ImportExportDialog> {
  late PickerRepository pickerRepository = watch();

  OperationStatus status = OperationStatus.idle;

  @override
  Widget build(BuildContext context) {
    return FDialog(
      actions: [
        FButton(
          onPress: status == OperationStatus.exporting
              ? null
              : () async {
                  status = OperationStatus.exporting;
                  rebuild();
                  final path = await pickerRepository.pickDirectoryPath();
                  if (path == null) {
                    status = OperationStatus.idle;
                    rebuild();
                    return;
                  }

                  print('file');
                  navigator.back();
                  status = OperationStatus.idle;
                  rebuild();
                },
          child: Text('Export'),
          prefix: status == OperationStatus.exporting
              ? FCircularProgress.loader()
              : Icon(FIcons.upload),
        ),
        FButton(
          onPress: status == OperationStatus.importing
              ? null
              : () async {
                  status = OperationStatus.importing;
                  rebuild();

                  final path = await pickerRepository.pickFilePath();
                  status = OperationStatus.idle;
                  rebuild();
                  if (path == null) return;
                  final file = File(path);
                  final string = await file.readAsString();
                  final json = jsonDecode(string);
                  navigator.back(json);
                },
          child: Text('Import'),
          prefix: status == OperationStatus.importing
              ? FCircularProgress.loader()
              : Icon(FIcons.download),
        ),
      ],
    );
  }
}
