import 'dart:convert';

import 'package:doctor_on_duty/domain/api/import_export_repository.dart';
import 'package:doctor_on_duty/domain/reads/settings.dart';
import 'package:doctor_on_duty/main.dart';

import '../domain/api/navigator.dart';

Map<String, dynamic> json = {};

class SettingsPage extends UI {
  const SettingsPage({super.key});

  void toggleDark() {
    onDarkChanged(!darkRead.state);
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Settings'.text(),
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.x),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        children: [
          FButton(
            child: Icon(
              darkRead.state ? FIcons.moon : FIcons.sun,
              size: 50,
            ),
            onPress: () => toggleDark(),
          ),
          FButton(
            onPress: () async {
              final result = await navigator.dialog<Map<String, dynamic>>(
                ImportExportDialog(),
              );
              if (result == null) return;
              json = result;
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
                ),
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

OperationStatus status = OperationStatus.idle;

class ImportExportDialog extends UI {
  const ImportExportDialog({super.key});
  @override
  // late PickerRepository pickerRepository = watch();
  @override
  Widget build(BuildContext context) {
    return FDialog(
      actions: [
        FButton(
          onPress: status == OperationStatus.exporting
              ? null
              : () async {
                  status = OperationStatus.exporting;
                  await exportInAppData([0]);
                  // final path = await pickerRepository.pickDirectoryPath();
                  status = OperationStatus.idle;
                  navigator.back();
                },
          prefix: status == OperationStatus.exporting
              ? FCircularProgress.loader()
              : Icon(FIcons.upload),
          child: Text('Export'),
        ),
        FButton(
          onPress: status == OperationStatus.importing
              ? null
              : () async {
                  status = OperationStatus.importing;
                  final path = 0 as dynamic;
                  status = OperationStatus.idle;
                  if (path == null) return;
                  final file = File(path);
                  final string = await file.readAsString();
                  final json = jsonDecode(string);
                  navigator.back(json);
                },
          prefix: status == OperationStatus.importing
              ? FCircularProgress.loader()
              : Icon(FIcons.download),
          child: Text('Import'),
        ),
      ],
    );
  }
}
