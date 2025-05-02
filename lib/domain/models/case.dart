import 'package:doctor_on_duty/domain/models/chapter.dart';
import 'package:doctor_on_duty/domain/repository.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Case extends Model {
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
