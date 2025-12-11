import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/main.dart';

class EditChapterDialog extends StatelessWidget {
  const EditChapterDialog({super.key});

  // Modifier<Chapter> get chapter => chaptersApi.editRM;
  void okay() {
    // chaptersApi.update(chapter());
    cancel();
  }

  void cancel() {
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
