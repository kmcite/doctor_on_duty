import 'package:doctor_on_duty/chapters/chapters_bloc.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/navigation/navigation_repository.dart';
import 'package:forui/forui.dart';

import '../chapters/chapter.dart';
import 'topic.dart';
import 'topics_repository.dart';

final addTopicBloc = AddTopicBloc();

class AddTopicBloc {
  final topicRM = RM.inject(() => Topic());
  Topic get topic => topicRM.state;
  set topic(Topic value) => topicRM
    ..state = value
    ..notify();

  void name(String value) => topic = topic..name = value;
  void save() {
    topicsRepository.put(topic);
    navigationRepository.back();
  }

  void chapter(Chapter chapter) => topic = topic..chapter = chapter;
  bool isChapterSelected(Chapter chapter) => topic.chapter != chapter;
  void openDialog() {
    navigationRepository.toDialog(AddTopicDialog());
  }

  void closeDialog() {
    navigationRepository.back();
  }
}

class AddTopicDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: Text('Add Topic'),
      body: FTextField(
        initialValue: addTopicBloc.topic.name,
        onChange: addTopicBloc.name,
      ),
      actions: [
        FTileGroup(
          description: addTopicBloc.topic.chapter.name.text(),
          label: Text('select chapter'),
          children: chaptersBloc.chapters.map(
            (chapter) {
              return FTile(
                enabled: addTopicBloc.isChapterSelected(chapter),
                title: chapter.name.text(),
                onPress: () => addTopicBloc.chapter(chapter),
              );
            },
          ).toList(),
        ),
        FButton(
          onPress: () => addTopicBloc.save(),
          label: Text('save'),
        ),
        FButton(
          onPress: () => addTopicBloc.closeDialog(),
          label: Text('cancel'),
        ),
      ],
    );
  }
}
