import 'package:doctor_on_duty/domain/api/chapters_api.dart'
    show chaptersRepository;
import 'package:doctor_on_duty/domain/api/topics_repository.dart'
    show topicsRepository;
import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import '../../main.dart';
import '../../domain/models/chapter.dart';

mixin ChaptersBloc {
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
        .state
        // .where((topic) {
        //   return topic.chapter.id == chapter.id;
        // })
        .length;
  }

  final editing = RM.inject(() => true);
  void toggleEditing() => editing.state = (!editing.state);

  final chapters = RM.injectStream(chaptersRepository.watchAll);
  final topics = RM.injectStream(topicsRepository.watchAll);
  bool get loading => chapters.isWaiting || topics.isWaiting;
  void addNewChapter() {
    // chaptersApi.insert(
    //   Chapter(),
    // );
  }

  // Modifier<Chapter> get chapter => chaptersApi.editRM;
  void editChapter(Chapter _chapter) {
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
        actions: [
          FButton.icon(
            onPress: navigator.back,
            child: FIcon(FAssets.icons.arrowLeft),
          ),
          FButton.icon(
            style:
                editing.state ? FButtonStyle.primary : FButtonStyle.destructive,
            child:
                FIcon(editing.state ? FAssets.icons.check : FAssets.icons.pen),
            onPress: toggleEditing,
          ),
          FButton.icon(
            child: FIcon(FAssets.icons.plus),
            onPress: addNewChapter,
          ),
        ],
      ),
      content: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: chapters.state.length,
              itemBuilder: (context, index) {
                final _chapter = chapters.state.elementAt(index);
                return FTile(
                  key: Key(_chapter.id.toString()),
                  title: Text(_chapter.name),
                  suffixIcon: FButton.icon(
                    style: FButtonStyle.destructive,
                    child: FIcon(FAssets.icons.delete),
                    onPress: () {
                      removeChapter(_chapter);
                    },
                  ),
                  onPress: () => editChapter(_chapter),
                  subtitle: numberOfTopics(_chapter).text(),
                );
              },
            ),
    );
  }
}

class EditChapterDialog extends UI {
  // Modifier<Chapter> get chapter => chaptersApi.editRM;
  okay() {
    // chaptersApi.update(chapter());
    cancel();
  }

  cancel() {
    navigator.back();
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: Text('Edit Chapter'),
      body: Column(
        children: [
          FTextField(
            label: 'Name'.text(),
            // initialValue: chapter().name,
            // onChange: (value) => chapter(chapter().copyWith(name: value)),
          ),
          FTextField(
            label: 'Description'.text(),
            // initialValue: chapter().description,
            // onChange: (value) =>
            //     chapter(chapter().copyWith(description: value)),
          ),
          FTextField(
            label: 'Author'.text(),
            // initialValue: chapter().author,
            // onChange: (value) => chapter(chapter().copyWith(author: value)),
          ),
          FTextField(
            label: 'Page Count'.text(),
            // initialValue: chapter().pageCount,
            // onChange: (value) => chapter(
            //   chapter().copyWith(
            //     pageCount: value,
            //   ),
            // ),
          ),
        ],
      ),
      actions: [
        FButton(
          onPress: okay,
          label: 'okay'.text(),
        ),
        FButton(
          onPress: cancel,
          label: 'cancel'.text(),
        ),
      ],
      direction: Axis.horizontal,
    );
  }
}
