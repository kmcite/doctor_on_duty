import 'package:doctor_on_duty/topics/topic.dart';
import 'package:manager/collection.dart';

class TopicsRepository extends Collection<Topic> {
  TopicsRepository({required super.fromJson});
}

final topicsRepository = TopicsRepository(
  fromJson: Topic.fromJson,
);
