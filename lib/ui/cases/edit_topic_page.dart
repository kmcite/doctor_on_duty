// ignore_for_file: unused_field

import 'package:doctor_on_duty/domain/models/chapter.dart';
import 'package:doctor_on_duty/domain/api/chapters_api.dart';
import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/domain/api/topics_repository.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import '../../main.dart';

mixin class EditTopicBloc {
  final topicsRM = RM.injectStream(topicsRepository.watchAll);
  final chaptersRM = RM.injectStream(chaptersRepository.watchAll);
  bool get loading => chaptersRM.isWaiting || topicsRM.isWaiting;
  Topic? byId(int id) => topicsRM.state.where(
        (test) {
          return test.id == id;
        },
      ).firstOrNull;
  Modifier<Topic> get edit => throw topicsRepository;

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
}

class EditTopicPage extends UI with EditTopicBloc {
  EditTopicPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text(edit().name),
        prefixActions: [
          FHeaderAction.back(onPress: navigator.back),
        ],
        suffixActions: [
          // hasChanges
          //     ? FHeaderAction(
          //       onPress: save,
          //       icon: FIcon(FAssets.icons.save),
          //     )
          //     : FHeaderAction.back(onPress: back),
        ],
      ),
      content: ListView(
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
            initialValue: edit().name,
            onChange: (value) {
              // edit().copyWith(name: value);
              // put(topic.copyWith(name: value));
            },
            maxLines: 1,
          ),
          FTextField(
            label: Text('Enter topic description'),
            initialValue: edit().description,
            onChange: (value) {
              // put(
              //   topic.copyWith(description: value),
              // );
            },
            maxLines: 10,
          ),
          FTextField(
            label: Text('Enter topic definition'),
            initialValue: edit().definition,
            onChange: (value) {
              // put(
              //   topic.copyWith(definition: value),
              // );
            },
            maxLines: 10,
          ),
          FTextField(
            label: Text('Enter topic epidemiology'),
            initialValue: edit().epidemiology,
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
