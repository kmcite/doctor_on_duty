// import 'package:copy_with_extension/copy_with_extension.dart';
// import 'package:floor/floor.dart';

// part 'topic.g.dart';

// @entity
// @CopyWith()
import 'package:doctor_on_duty/domain/repository.dart';

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
