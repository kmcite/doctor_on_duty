import 'package:doctor_on_duty/domain/models/topic.dart';
import 'package:doctor_on_duty/domain/repository.dart';

class TopicsRepository extends Repository<Topic> {}

final topicsRepository = TopicsRepository();
