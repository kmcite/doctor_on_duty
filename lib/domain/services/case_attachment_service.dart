import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CaseAttachmentService {
  const CaseAttachmentService();

  static const _folder = 'case_images';

  Future<String> imagesRoot() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, _folder));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  /// Saves [source] into case folder; returns relative path for [Patient.imagePaths].
  Future<String> saveImage(File source, int caseId) async {
    final root = await imagesRoot();
    final caseDir = Directory(p.join(root, '$caseId'));
    if (!await caseDir.exists()) await caseDir.create(recursive: true);
    final name = '${const Uuid().v4()}${p.extension(source.path)}';
    final dest = File(p.join(caseDir.path, name));
    await source.copy(dest.path);
    return p.join(_folder, '$caseId', name).replaceAll(r'\', '/');
  }

  Future<File?> resolveFile(String relativePath) async {
    final root = await getApplicationDocumentsDirectory();
    final file = File(p.join(root.path, relativePath));
    if (await file.exists()) return file;
    return null;
  }

  Future<void> deleteRelative(String relativePath) async {
    final f = await resolveFile(relativePath);
    if (f != null && await f.exists()) await f.delete();
  }
}
