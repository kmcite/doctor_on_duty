// ignore_for_file: unused_field

import 'package:doctor_on_duty/domain/api/chapters_api.dart';
import 'package:doctor_on_duty/domain/api/topics_repository.dart';
import 'package:doctor_on_duty/ui/cases/add_topic_dialog.dart';
import 'package:doctor_on_duty/ui/cases/edit_topic_page.dart';
import 'package:doctor_on_duty/ui/cases/view_topic_page.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/settings.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import 'package:doctor_on_duty/domain/models/chapter.dart';

import '../../domain/models/topic.dart';

mixin class TopicsBloc {
  final chapter = RM.inject<Chapter?>(() => null);
  final topics = RM.injectStream(topicsRepository.watchAll);
  final chapters = RM.injectStream(chaptersRepository.watchAll);
  bool get loading => chapters.isWaiting || topics.isWaiting;
  Topic? byId(int id) => topics.state.where(
        (test) {
          return test.id == id;
        },
      ).firstOrNull;

  void chapterSelected(Chapter value) {
    if (chapter.state?.id == value.id) {
      chapter.state = (null);
    } else {
      chapter.state = (value);
    }
  }

  Iterable<Topic> get filteredTopics {
    if (chapter.state?.id == null) {
      return topics.state;
    } else {
      return topics.state.where(
        (topic) {
          return topic.id == chapter.state?.id;
        },
      );
    }
  }

  Modifier<Topic> get view => throw topicsRepository;
  void viewTopic(Topic topic) {
    // topicsRepository.viewRM.state = topic.id;
    // to(ViewTopicPage());
    view(topic);
    navigator.to(ViewTopicPage());
  }

  Modifier<Topic> get edit => throw topicsRepository;
  void editTopic(Topic topic) {
    edit(topic);
    // topicsRepository.editRM.state = topic.id;
    navigator.to(EditTopicPage());
  }

  void emit(copyWith) {}
}

class TopicsPage extends UI with TopicsBloc {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text('Topics'),
        prefixActions: [
          FHeaderAction(
            icon: FIcon(FAssets.icons.captions),
            // 1 navigation
            onPress: () {
              navigator.to(ChaptersPage());
            },
          ),
          FHeaderAction(
            icon: FIcon(FAssets.icons.settings),
            // 2 navigation
            onPress: () {
              navigator.to(SettingsPage());
            },
          ),
        ],
        suffixActions: [
          FButton.icon(
            onPress: () {},
            child: FIcon(FAssets.icons.refreshCw),
          ),
          FButton.icon(
            onPress: () {
              navigator.dialog(AddTopicDialog());
            },
            child: FIcon(FAssets.icons.plus),
          ),
        ],
      ),
      content: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: chapters.state.map((chapter) {
                      return FTappable(
                        child: FBadge(
                          label: chapter.name.text(),
                          style: switch (chapter.id == chapter.id) {
                            true => FBadgeStyle.primary,
                            _ => FBadgeStyle.secondary,
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
                    itemCount: topics.state.length,
                    itemBuilder: (context, index) {
                      final topic = topics.state.elementAt(index);
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
                          style: FButtonStyle.primary,
                          onPress: () {
                            editTopic(topic);
                          },
                          child: FIcon(FAssets.icons.penLine),
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
