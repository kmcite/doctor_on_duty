class Symptom {
  Symptom();
  String id = randomId;
  String name = '';
  String description = '';
  String examination = '';
  String investigations = '';
  String differentials = '';
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'examination': examination,
      'differentials': differentials,
      'investigations': investigations,
    };
  }

  Symptom.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    examination = json['examination'] ?? '';
    differentials = json['differentials'] ?? '';
    investigations = json['investigations'] ?? '';
  }

  static String get randomId => 'null';
}
