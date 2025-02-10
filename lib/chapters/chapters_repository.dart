import 'package:doctor_on_duty/chapters/chapter.dart';
import 'package:manager/collection.dart';

final chaptersRepository = ChaptersRepository(fromJson: Chapter.fromJson);

class ChaptersRepository extends Collection<Chapter> {
  ChaptersRepository({
    required super.fromJson,
  });
}
