import 'package:doctor_on_duty/objectbox.g.dart';

import '../../main.dart';

@Entity()
class Topic extends Model {
  int id = 0;
  String name = '';
  String definition = '';
  String description = '';
  String epidemiology = '';
  // Chapter chapter;
  DateTime createdAt = DateTime.now();
  int? chapterId;
}
