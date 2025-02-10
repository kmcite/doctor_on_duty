import 'package:doctor_on_duty/chapters/chapters_bloc.dart';
import 'package:doctor_on_duty/navigation/navigator.dart';
import 'package:forui/forui.dart';

import '../main.dart';
import 'chapter.dart';

/// LOCAL STATE
final _editModeRM = RM.inject(() => false);
bool get _editMode => _editModeRM.state;
set _editMode(bool value) => _editModeRM.state = value;

class ChaptersPage extends UI {
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text(
          'Chapters',
        ),
        actions: [
          FHeaderAction.back(
            onPress: navigator.back,
          ),
          FHeaderAction(
            icon: FIcon(_editMode ? FAssets.icons.check : FAssets.icons.pen),
            onPress: () => _editMode = !_editMode,
          ),
        ],
      ),
      content: ListView.builder(
        itemCount: chaptersBloc.chapters.length + 1,
        itemBuilder: (context, index) {
          if (index == chaptersBloc.chapters.length) {
            return _editMode
                ? FButton(
                    onPress: () {
                      chaptersBloc.put(Chapter()..name = '');
                    },
                    label: Text('Add New Chapter'),
                  )
                : const SizedBox.shrink();
          }
          final chapter = chaptersBloc.chapters[index];
          if (_editMode) {
            return FTextField(
              label: Text('chapter name'),
              initialValue: chapter.name,
              onChange: (value) {
                chaptersBloc.put(chapter..name = value);
              },
            );
          } else {
            return FCard(
              title: Text(chapter.name),
              image: FButton.icon(
                child: FIcon(FAssets.icons.delete),
                onPress: () {
                  final id = chaptersBloc.chapters.elementAt(index).id;
                  chaptersBloc.remove(id);
                },
              ),
              subtitle:
                  'there are ${chaptersBloc.numberOfTopics(chapter)} topics'
                      .text(),
            ).pad();
          }
        },
      ),
    );
  }
}
