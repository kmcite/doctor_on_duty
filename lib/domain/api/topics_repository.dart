import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/utils/repositories.dart';

class TopicsRepository extends CrudRepository<Topic> {}

final topicsRepository = TopicsRepository();
