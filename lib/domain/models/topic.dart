import '../../main.dart';

class Topic extends Model {
  int id = 0;
  String name;
  String definition;
  String description;
  String epidemiology;
  // Chapter chapter;
  DateTime createdAt;
  Topic({
    this.name = '',
    this.definition = '',
    this.description = '',
    this.epidemiology = '',
    // Chapter? chapter,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now()
  // chapter = chapter ?? Chapter()
  ;
}
