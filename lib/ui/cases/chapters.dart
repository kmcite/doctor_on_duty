import 'package:doctor_on_duty/domain/api/chapters_repository.dart'
    show chaptersRepository;
import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/domain/api/topics_repository.dart'
    show topicsRepository;
import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/ui/cases/edit_chapter_dialog.dart';

import '../../domain/models/chapter.dart';
import '../../main.dart';

mixin ChaptersBloc {
  final editing = RM.inject(() => true);
  void toggleEditing() => editing.state = (!editing.state);

  List<Chapter> get chapters => chaptersRepository.getAll();
  List<Topic> get topics => topicsRepository.getAll();
  bool get loading => false;
  void updateChapter(Chapter chapter) {
    // chaptersApi.update(chapter);
  }

  void updateTopic(Topic topic) {
    // topicsRepository.update(topic);
  }

  void insertChapter(Chapter chapter) {
    // chaptersApi.insert(chapter);
  }

  void insertTopic(Topic topic) {
    // topicsRepository.insert(topic);
  }

  void removeChapter(Chapter chapter) {
    // chaptersApi.remove(chapter);
  }

  void removeTopic(Topic topic) {
    // topicsRepository.remove(topic);
  }

  int numberOfTopics(Chapter chapter) {
    return topics
        // .where((topic) {
        //   return topic.chapter.id == chapter.id;
        // })
        .length;
  }

  void addNewChapter() {
    // chaptersApi.insert(
    //   Chapter(),
    // );
  }

  // Modifier<Chapter> get chapter => chaptersApi.editRM;
  void editChapter(Chapter chapter) {
    // chapter(_chapter);
    navigator.dialog(EditChapterDialog());
  }
}

class ChaptersPage extends UI with ChaptersBloc {
  ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Chapters'),
        suffixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.arrowLeft),
          ),
          FButton.icon(
            style: editing.state
                ? FButtonStyle.primary()
                : FButtonStyle.destructive(),
            onPress: toggleEditing,
            child: Icon(editing.state ? FIcons.check : FIcons.pen),
          ),
          FButton.icon(
            onPress: addNewChapter,
            child: Icon(FIcons.plus),
          ),
        ],
      ),
      child: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters.elementAt(index);
                return FTile(
                  key: Key(chapter.id.toString()),
                  title: Text(chapter.name),
                  suffix: FButton.icon(
                    style: FButtonStyle.destructive(),
                    child: Icon(FIcons.delete),
                    onPress: () {
                      removeChapter(chapter);
                    },
                  ),
                  onPress: () => editChapter(chapter),
                  subtitle: numberOfTopics(chapter).text(),
                );
              },
            ),
    );
  }
}
