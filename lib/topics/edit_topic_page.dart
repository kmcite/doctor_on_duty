import 'package:doctor_on_duty/chapters/chapter.dart';
import 'package:doctor_on_duty/chapters/chapters_repository.dart';
import 'package:doctor_on_duty/topics/topic.dart';
import 'package:doctor_on_duty/topics/topics_repository.dart';
import 'package:forui/forui.dart';

import '../main.dart';
import '../navigation/navigator.dart';

final editTopicRepository = EditTopicRepository();

class EditTopicRepository {
  String id = '';
}

final editTopicBloc = EditTopicBloc();

class EditTopicBloc {
  final topicRM =
      RM.inject<Topic?>(() => topicsRepository.get(editTopicRepository.id));
  void put(Topic topic) {
    topicRM
      ..state = topic
      ..notify();
  }

  bool get hasChanges => topic != topicsRepository.get(editTopicRepository.id);

  Topic? get topic => topicRM.state;
  Topic? get(String id) => topicsRepository.get(editTopicRepository.id);
  void save() {
    topicsRepository.put(topic!);
    navigator.back();
  }

  void chapterSelected(Chapter chapter) {
    put(topic!..chapter = chapter);
  }

  Iterable<Chapter> get chapters => chaptersRepository.getAll();
}

class EditTopicPage extends UI {
  const EditTopicPage({super.key});
  @override
  Widget build(BuildContext context) {
    final topic = editTopicBloc.topic!;
    return FScaffold(
      header: FHeader(
        title: Text(topic.name),
        actions: [
          editTopicBloc.hasChanges
              ? FHeaderAction(
                  onPress: editTopicBloc.save,
                  icon: FIcon(FAssets.icons.save),
                )
              : FHeaderAction.back(onPress: navigator.back),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FLabel(
            label: 'Select chapter'.text(),
            description: 'selecting chapter for this topic'.text(),
            axis: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: editTopicBloc.chapters.map(
                  (chapter) {
                    return FTappable(
                      child: FBadge(
                              label: chapter.name.text(),
                              style: switch (chapter.id == topic.chapter.id) {
                                true => FBadgeStyle.primary,
                                _ => FBadgeStyle.secondary,
                              })
                          .pad(),
                      onPress: () => editTopicBloc.chapterSelected(chapter),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          FTextField(
            label: Text('enter topic name'),
            initialValue: topic.name,
            onChange: (value) {
              editTopicBloc.put(topic..name = value);
            },
            maxLines: 1,
          ),
          FTextField(
            label: Text('Enter topic description'),
            initialValue: topic.description,
            onChange: (value) {
              editTopicBloc.put(topic..description = value);
            },
            maxLines: 10,
          ),
          FTextField(
            label: Text('Enter topic definition'),
            initialValue: topic.definition,
            onChange: (value) {
              editTopicBloc.put(topic..definition = value);
            },
            maxLines: 10,
          ),
          FTextField(
            label: Text('Enter topic epidemiology'),
            initialValue: topic.epidemiology,
            onChange: (value) {
              editTopicBloc.put(topic..epidemiology = value);
            },
            maxLines: 10,
          ),
        ],
      ),
    );
  }
}
