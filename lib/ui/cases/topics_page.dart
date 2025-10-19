// ignore_for_file: unused_field

import 'package:doctor_on_duty/domain/api/chapters_repository.dart';
import 'package:doctor_on_duty/domain/api/topics_repository.dart';
import 'package:doctor_on_duty/ui/cases/add_topic_dialog.dart';
import 'package:doctor_on_duty/ui/cases/edit_topic_page.dart';
import 'package:doctor_on_duty/ui/cases/view_topic_page.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/settings.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/domain/models/chapter.dart';
import 'package:doctor_on_duty/domain/models/topic.dart';

class TopicsPage extends StatefulWidget {
  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  late TopicsRepository topicsRepository = watch();
  late ChaptersRepository chaptersRepository = watch();

  Chapter? chapter;

  Iterable<Topic> get topics => topicsRepository.getAll();
  Iterable<Chapter> get chapters => chaptersRepository.getAll();

  bool loading = false;
  Topic? byId(int id) => topicsRepository.get(id);

  void chapterSelected(Chapter value) {
    if (chapter?.id == value.id) {
      chapter = null;
    } else {
      chapter = value;
    }
    rebuild();
  }

  Iterable<Topic> get filteredTopics {
    if (chapter?.id == null) {
      return topics;
    } else {
      return topics.where(
        (topic) {
          return topic.id == chapter?.id;
        },
      );
    }
  }

  Topic topic([Topic? v]) => throw topicsRepository;
  void viewTopic(Topic topic) {
    // topicsRepository.viewRM.state = topic.id;
    // to(ViewTopicPage());
    // view(topic);
    navigator.to(ViewTopicPage());
  }

  Topic edit([Topic? v]) => throw topicsRepository;
  void editTopic(Topic topic) {
    edit(topic);
    // topicsRepository.editRM.state = topic.id;
    navigator.to(EditTopicPage());
  }

  void emit(copyWith) {}

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text('Topics'),
        prefixes: [
          FHeaderAction(
            icon: Icon(FIcons.captions),
            // 1 navigation
            onPress: () {
              navigator.to(ChaptersPage());
            },
          ),
          FHeaderAction(
            icon: Icon(FIcons.settings),
            // 2 navigation
            onPress: () {
              navigator.to(SettingsPage());
            },
          ),
        ],
        suffixes: [
          FButton.icon(
            onPress: () {},
            child: Icon(FIcons.refreshCw),
          ),
          FButton.icon(
            onPress: () {
              navigator.dialog(AddTopicDialog());
            },
            child: Icon(FIcons.plus),
          ),
        ],
      ),
      child: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: chapters.map((chapter) {
                      return FTappable(
                        child: FBadge(
                          child: chapter.name.text(),
                          style: switch (chapter.id == chapter.id) {
                            true => FBadgeStyle.primary(),
                            _ => FBadgeStyle.secondary(),
                          },
                        ).pad(),
                        onPress: () => chapterSelected(chapter),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    // divider: FTileDivider.full,
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics.elementAt(index);
                      return FTile(
                        title: topic.name.text(),
                        subtitle: Column(
                          children: [
                            topic.description.text(),
                            // topic.chapter.name.text(),
                          ],
                        ),
                        onPress: () {
                          viewTopic(topic);
                        },
                        details: FButton.icon(
                          style: FButtonStyle.primary(),
                          onPress: () {
                            editTopic(topic);
                          },
                          child: Icon(FIcons.penLine),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
