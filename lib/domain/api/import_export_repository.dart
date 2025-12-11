import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Import data from a file system into application data
class ImportRepository<T> {
  Future<T> import(File file) async {
    throw UnimplementedError();
  }
}

/// Export application data to the file system
@Deprecated('Okat')
class ExportRepository<T> {
  Future<File> export(T data, String path) async {
    throw UnimplementedError();
  }
}

/// IMPLEMENTATIONS

/// in-app data
/// dynamic for now but when finalized will be typed
Future<void> exportInAppData(dynamic data) async {
  await FilePicker.platform.saveFile(
    dialogTitle: 'EXPORT in-app data',
    fileName: 'data.json',
    type: FileType.custom,
    bytes: Uint8List.fromList(data),
    allowedExtensions: ['json'],
  );
}
