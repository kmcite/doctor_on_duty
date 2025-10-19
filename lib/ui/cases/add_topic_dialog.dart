import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import '../../domain/models/chapter.dart';
import '../../domain/models/topic.dart';

final topic = RM.inject(() => Topic());
final chapters = RM.inject(() => <Chapter>[]);
mixin AddTopicBloc {
  bool isChapterSelected(Chapter chapter) => topic.state.id != chapter.id;

  void name(String value) {
    // topic((topic().copyWith(name: value)));
  }
  void chapter(Chapter value) {
    // topic(topic().copyWith());
  }
  void save() {
    // topicsRepository.insert(topic());
    navigator.back();
    print('save');
  }
}

class AddTopicDialog extends StatelessWidget with AddTopicBloc {
  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: Text('Add Topic'),
      body: Column(
        children: [
          FTextField(
            // initialValue: topic().name,
            onChange: name,
          ).pad(),
          FTileGroup.builder(
            count: chapters.state.length,
            tileBuilder: (context, index) {
              final chapter_ = chapters.state.elementAt(index);
              return FTile(
                enabled: isChapterSelected(chapter_),
                title: chapter_.name.text(),
                onPress: () {
                  chapter(chapter_);
                },
              );
            },
          ).pad(),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        FButton(onPress: () => save(), child: Text('save')),
        FButton(
          onPress: () => navigator.back(),
          child: Text('cancel'),
        ),
      ],
    );
  }
}
