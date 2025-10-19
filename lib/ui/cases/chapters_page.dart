import 'package:doctor_on_duty/domain/api/chapters_repository.dart'
    show ChaptersRepository;
import 'package:doctor_on_duty/domain/api/topics_repository.dart'
    show TopicsRepository;
import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import '../../main.dart';
import '../../domain/models/chapter.dart';

mixin ChaptersBloc {}

class ChaptersPage extends StatefulWidget with ChaptersBloc {
  ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  late ChaptersRepository chaptersRepository = watch();
  late TopicsRepository topicsRepository = watch();

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
  void editChapter(Chapter _chapter) {
    // chapter(_chapter);
    navigator.dialog(EditChapterDialog());
  }

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
            child: Icon(editing.state ? FIcons.check : FIcons.pen),
            onPress: toggleEditing,
          ),
          FButton.icon(
            child: Icon(FIcons.plus),
            onPress: addNewChapter,
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
                final _chapter = chapters.elementAt(index);
                return FTile(
                  key: Key(_chapter.id.toString()),
                  title: Text(_chapter.name),
                  suffix: FButton.icon(
                    style: FButtonStyle.destructive(),
                    child: Icon(FIcons.delete),
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

class EditChapterDialog extends StatelessWidget {
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
          child: 'okay'.text(),
        ),
        FButton(
          onPress: cancel,
          child: 'cancel'.text(),
        ),
      ],
      direction: Axis.horizontal,
    );
  }
}
