import 'package:doctor_on_duty/domain/models/chapter.dart';
import 'package:doctor_on_duty/utils/repositories.dart';

class ChaptersRepository extends CrudRepository<Chapter> {}

final chaptersRepository = ChaptersRepository();
