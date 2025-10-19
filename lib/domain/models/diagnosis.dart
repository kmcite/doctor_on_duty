import 'package:doctor_on_duty/main.dart';
import 'package:objectbox/objectbox.dart';

class Diagnosis extends Model {
  @Id()
  int id = 0;
  Diagnosis() {
    validate();
  }
  String name = '';
  String description = '';
  String symptoms = '';
  String examination = '';
  String investigations = '';
  String differentials = '';
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'symptoms': symptoms,
      'examination': examination,
      'differentials': differentials,
      'investigations': investigations,
    };
  }

  Diagnosis.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    symptoms = json['symptoms'] ?? '';
    examination = json['examination'] ?? '';
    differentials = json['differentials'] ?? '';
    investigations = json['investigations'] ?? '';
    validate();
  }
  void validate() {
    if (name.length > 50) {
      throw Exception('Name is too long');
    }
    if (description.length > 300) {
      throw Exception('Description is too long');
    }
    if (symptoms.length > 150) {
      throw Exception('Symptoms are too long');
    }
    if (examination.length > 300) {
      throw Exception('Examination is too long');
    }
    if (differentials.length > 300) {
      throw Exception('Differentials are too long');
    }
    if (investigations.length > 300) {
      throw Exception('Investigations are too long');
    }
  }

  static const nameLength = 50;
  static const descriptionLength = 300;
  static const symptomsLength = 150;
  static const examinationLength = 300;
  static const differentialsLength = 300;
  static const investigationsLength = 300;

  static String get randomId => 'null';
}
