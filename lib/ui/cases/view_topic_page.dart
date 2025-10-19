import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/domain/api/topics_repository.dart';

import '../../main.dart';
import '../../domain/api/navigator.dart';

mixin ViewTopicBloc {
  Topic topic([Topic? v]) => throw topicsRepository;
  // Topic get topic => topicsRepository.get(id as int)!;
  // late final back = navigationRepository.back;
}

class ViewTopicPage extends StatelessWidget with ViewTopicBloc {
  ViewTopicPage();
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text(topic().name),
        suffixes: [
          FHeaderAction.back(
            onPress: navigator.back,
          ),
        ],
      ),
      child: FCard(
        title: topic().name.text(),
        subtitle: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(topic().definition),
              Text(topic().description),
              Text(topic().epidemiology),
            ],
          ),
        ),
        image: Column(
          children: [
            // (topic().chapter.name).text(),
            // (topic().chapter.description).text(),
          ],
        ),
      ).pad(),
    );
  }
}
