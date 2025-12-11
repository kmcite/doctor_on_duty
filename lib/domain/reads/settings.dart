import 'package:doctor_on_duty/main.dart';

final darkRead = RM.inject(() => false);

void onDarkChanged(bool value) {
  darkRead.state = value;
}

// final topicsRead = ValueNotifier(<int, Topic>{});

// void onTopicsChanged(Map<int, Topic> value) {
//   topicsRead.value = Map.from(value);
// }

// void onTopicAdded(Topic topic) {
//   onTopicsChanged(topicsRead.value..[topic.id] = topic);
// }

// void onTopicRemoved(int id) {
//   onTopicsChanged(topicsRead.value..remove(id));
// }

// void onTopicsRemoved() {
//   onTopicsChanged(<int, Topic>{});
// }
