import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Exports app data to a JSON file
Future<void> exportInAppData(String jsonString) async {
  await FilePicker.platform.saveFile(
    dialogTitle: 'Export Doctor on Duty Data',
    fileName:
        'doctor_on_duty_backup_${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}.json',
    type: FileType.custom,
    bytes: Uint8List.fromList(jsonString.codeUnits),
    allowedExtensions: ['json'],
  );
}

/// Imports data from a selected file
Future<Map<String, dynamic>?> importFromFileSystem() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
    dialogTitle: 'Import Doctor on Duty Data',
  );

  if (result == null || result.files.isEmpty) return null;

  final file = File(result.files.first.path!);
  final string = await file.readAsString();

  try {
    final json = jsonDecode(string) as Map<String, dynamic>;
    return json;
  } catch (e) {
    throw Exception('Invalid JSON file: $e');
  }
}

/// Validates imported data structure
bool validateImportedData(Map<String, dynamic> data) {
  final validKeys = ['symptoms', 'diagnoses', 'topics', 'cases', 'duties'];

  // Check if at least one valid key exists
  if (!validKeys.any((key) => data.containsKey(key))) {
    return false;
  }

  // Validate symptoms if present
  if (data.containsKey('symptoms')) {
    final symptoms = data['symptoms'] as List?;
    if (symptoms == null || symptoms.isEmpty) return false;

    for (final symptom in symptoms) {
      if (!_isValidSymptom(symptom as Map<String, dynamic>)) {
        return false;
      }
    }
  }

  // Validate diagnoses if present
  if (data.containsKey('diagnoses')) {
    final diagnoses = data['diagnoses'] as List?;
    if (diagnoses == null || diagnoses.isEmpty) return false;

    for (final diagnosis in diagnoses) {
      if (!_isValidDiagnosis(diagnosis as Map<String, dynamic>)) {
        return false;
      }
    }
  }

  // Validate topics if present
  if (data.containsKey('topics')) {
    final topics = data['topics'] as List?;
    if (topics == null || topics.isEmpty) return false;

    for (final topic in topics) {
      if (!_isValidTopic(topic as Map<String, dynamic>)) {
        return false;
      }
    }
  }

  // Validate cases if present
  if (data.containsKey('cases')) {
    final cases = data['cases'] as List?;
    if (cases == null || cases.isEmpty) return false;

    for (final caze in cases) {
      if (!_isValidCase(caze as Map<String, dynamic>)) {
        return false;
      }
    }
  }

  // Validate duties if present
  if (data.containsKey('duties')) {
    final duties = data['duties'] as List?;
    if (duties == null || duties.isEmpty) return false;

    for (final duty in duties) {
      if (!_isValidDuty(duty as Map<String, dynamic>)) {
        return false;
      }
    }
  }

  return true;
}

bool _isValidSymptom(Map<String, dynamic> symptom) {
  return symptom.containsKey('name') &&
      symptom['name'] is String &&
      (symptom['name'] as String).isNotEmpty;
}

bool _isValidDiagnosis(Map<String, dynamic> diagnosis) {
  return diagnosis.containsKey('name') &&
      diagnosis['name'] is String &&
      (diagnosis['name'] as String).isNotEmpty;
}

bool _isValidTopic(Map<String, dynamic> topic) {
  return topic.containsKey('name') &&
      topic['name'] is String &&
      (topic['name'] as String).isNotEmpty;
}

bool _isValidCase(Map<String, dynamic> caze) {
  return caze.containsKey('patientName') &&
      caze['patientName'] is String &&
      (caze['patientName'] as String).isNotEmpty;
}

bool _isValidDuty(Map<String, dynamic> duty) {
  return duty.containsKey('date') &&
      duty.containsKey('shift') &&
      duty['shift'] is String &&
      (duty['shift'] as String).isNotEmpty;
}
