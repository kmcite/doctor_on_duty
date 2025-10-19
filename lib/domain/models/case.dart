import 'package:doctor_on_duty/utils/model.dart';
import 'package:objectbox/objectbox.dart';

import 'chapter.dart';

@Entity()
class Caze extends Model {
  @Id()
  int id = 0;
  String name = '';
  String description = '';
  String status = '';
  String type = 'emergency'; // or opd
  String category = 'general'; // or special
  String definition = '';
  String epidemiology = '';
  final chapter = ToOne<Chapter>();
}
