import 'package:doctor_on_duty/domain/repository.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Chapter extends Model {
  @Id()
  int id = 0;
  String name = '';
  String description = '';
  String author = '';
  String pageCount = '';
  @Property(type: PropertyType.date)
  DateTime publishedOn = DateTime.now();
}
