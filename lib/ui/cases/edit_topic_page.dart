// ignore_for_file: unused_field

import 'package:doctor_on_duty/domain/models/chapter.dart';
import 'package:doctor_on_duty/domain/api/chapters_repository.dart';
import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/domain/api/topics_repository.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import '../../main.dart';

mixin class EditTopicBloc {}

class EditTopicPage extends StatefulWidget with EditTopicBloc {
  EditTopicPage({super.key});

  @override
  State<EditTopicPage> createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  late TopicsRepository topicsRepository = watch();
  late ChaptersRepository chaptersRepository = watch();

  Iterable<Topic> get topics => topicsRepository.getAll();
  Iterable<Chapter> get chapters => chaptersRepository.getAll();

  bool get loading => false;
  Topic? byId(int id) => topics.where(
        (test) {
          return test.id == id;
        },
      ).firstOrNull;
  Topic edit([Topic? v]) => throw topicsRepository;

  String name([String? _value]) {
    if (_value != null) {
      edit(edit()..name = _value);
    }
    return edit().name;
  }

  bool get hasChanges {
    return edit() != byId(edit().id);
  }

  void save() {
    // topicsRepository.update(edit());
    navigator.back();
  }

  void chapterSelected(Chapter chapter) {
    // edit(edit().copyWith(chapter: chapter));
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text(edit().name),
        prefixes: [
          FHeaderAction.back(onPress: navigator.back),
        ],
        suffixes: [
          // hasChanges
          //     ? FHeaderAction(
          //       onPress: save,
          //       icon: FIcon(FAssets.icons.save),
          //     )
          //     : FHeaderAction.back(onPress: back),
        ],
      ),
      child: ListView(
        children: [
          // FLabel(
          //   label: 'Select chapter'.text(),
          //   description: 'selecting chapter for this topic'.text(),
          //   axis: Axis.vertical,
          // child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          //  /             // child: Row(
          // children:
          // chapters.map((chapter) {
          //   return FTappable(
          //     child:
          //         FBadge(
          //           label: chapter.name.text(),
          //           style: switch (chapter.id == topic.chapter.id) {
          //             true => FBadgeStyle.primary,
          //             _ => FBadgeStyle.secondary,
          //           },
          //         ).pad(),
          //     onPress: () {
          //       // chapterSelected(chapter);
          //     },
          //   );
          // }).toList(),
          // ),
          // ),
          // ),
          FTextField(
            label: Text('enter topic name'),
            initialText: edit().name,
            onChange: (value) {
              // edit().copyWith(name: value);
              // put(topic.copyWith(name: value));
            },
            maxLines: 1,
          ),
          FTextField(
            label: Text('Enter topic description'),
            initialText: edit().description,
            onChange: (value) {
              // put(
              //   topic.copyWith(description: value),
              // );
            },
            maxLines: 10,
          ),
          FTextField(
            label: Text('Enter topic definition'),
            initialText: edit().definition,
            onChange: (value) {
              // put(
              //   topic.copyWith(definition: value),
              // );
            },
            maxLines: 10,
          ),
          FTextField(
            label: Text('Enter topic epidemiology'),
            initialText: edit().epidemiology,
            onChange: (value) {
              // put(
              //   topic.copyWith(epidemiology: value),
              // );
            },
            maxLines: 10,
          ),
        ],
      ),
    );
  }
}
