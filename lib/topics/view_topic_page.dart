import 'package:doctor_on_duty/navigation/navigator.dart';
import 'package:doctor_on_duty/topics/topic.dart';
import 'package:doctor_on_duty/topics/topics_repository.dart';
import 'package:forui/forui.dart';

import '../main.dart';

final viewTopicRepository = ViewTopicRepository();

class ViewTopicRepository {
  String id = '';
}

final viewTopicBloc = ViewTopicBloc();

class ViewTopicBloc {
  Topic get topic => topicsRepository.get(viewTopicRepository.id)!;
}

class ViewTopicPage extends UI {
  const ViewTopicPage();
  @override
  Widget build(BuildContext context) {
    final topic = viewTopicBloc.topic;
    return FScaffold(
      header: FHeader(
        title: Text(topic.name),
        actions: [
          FHeaderAction.back(onPress: navigator.back),
        ],
      ),
      content: FCard(
        title: topic.name.text(),
        subtitle: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(topic.definition),
              Text(topic.description),
              Text(topic.epidemiology),
            ],
          ),
        ),
        image: Column(
          children: [
            (topic.chapter.name).text(),
            (topic.chapter.description).text(),
          ],
        ),
      ).pad(),
    );
  }
}
