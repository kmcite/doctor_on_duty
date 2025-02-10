import 'package:doctor_on_duty/chapters/chapters_repository.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/topics/topics_repository.dart';

import 'chapter.dart';

class ChaptersBloc {
  late final chaptersRM = RM.injectStream(
    () => chaptersRepository.watch(),
    initialState: chaptersRepository.getAll(),
  );

  List<Chapter> get chapters => chaptersRM.state;

  void put(Chapter chapter) {
    chaptersRepository.put(chapter);
  }

  void remove(String id) {
    chaptersRepository.delete(id);
  }

  int numberOfTopics(Chapter chapter) {
    return topicsRepository
        .getAll()
        .where((topic) => topic.chapter == chapter)
        .length;
  }
}

final ChaptersBloc chaptersBloc = ChaptersBloc();
