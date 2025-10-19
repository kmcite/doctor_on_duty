import 'package:doctor_on_duty/utils/repositories.dart';
import 'package:file_picker/file_picker.dart';

class PickerRepository extends Repository<String> {
  Future<String?> pickFilePath() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null) return null;
    final file = result.files.first;
    return file.path;
  }

  Future<String?> pickDirectoryPath() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result == null) return null;
    return result;
  }
}
