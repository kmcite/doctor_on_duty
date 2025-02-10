import 'package:doctor_on_duty/chapters/chapter.dart';
import 'package:doctor_on_duty/chapters/chapters_repository.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/navigation/navigation_repository.dart';
import 'package:doctor_on_duty/settings/settings_page.dart';
import 'package:doctor_on_duty/topics/add_topic_dialog.dart';
import 'package:doctor_on_duty/topics/topics_repository.dart';
import 'package:forui/forui.dart';
import 'edit_topic_page.dart';
import 'topic.dart';
import 'view_topic_page.dart';

final topicsBloc = TopicsBloc();

class TopicsBloc {
  final chapterRM = RM.inject<Chapter?>(() => null);
  Chapter? get chapter => chapterRM.state;
  set chapter(Chapter? value) => chapterRM
    ..state = value
    ..notify();
  void chapterSelected(Chapter value) {
    if (chapter?.id == value.id) {
      chapter = null;
    } else {
      chapter = value;
    }
  }

  Iterable<Topic> get topics {
    final topics = topicsRepository.getAll();

    if (chapter == null) {
      return topics;
    } else {
      return topics.where((topic) => topic.chapter.id == chapter?.id);
    }
  }

  Iterable<Chapter> get chapters => chaptersRepository.getAll();

  /// NavigationLogic
  void gotoChaptersPage() {
    navigationRepository.to(ChaptersPage());
  }

  void gotoSettingsPage() {
    navigationRepository.to(SettingsPage());
  }

  void gotoTopicViewPage(Topic topic) {
    viewTopicRepository.id = topic.id;
    navigationRepository.to(
      ViewTopicPage(),
    );
  }

  void gotoEditTopicPage(Topic topic) {
    editTopicRepository.id = topic.id;
    navigationRepository.to(EditTopicPage());
  }
}

class TopicsPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text('Topics'),
        actions: [
          FHeaderAction(
            icon: FIcon(FAssets.icons.cat),
            onPress: topicsBloc.gotoChaptersPage,
          ),
          FHeaderAction(
            icon: FIcon(FAssets.icons.settings),
            onPress: topicsBloc.gotoSettingsPage,
          ),
        ],
      ),
      content: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: topicsBloc.chapters.map(
                (chapter) {
                  return FTappable(
                    child: FBadge(
                            label: chapter.name.text(),
                            style: switch (
                                chapter.id == topicsBloc.chapter?.id) {
                              true => FBadgeStyle.primary,
                              _ => FBadgeStyle.secondary,
                            })
                        .pad(),
                    onPress: () => topicsBloc.chapterSelected(chapter),
                  );
                },
              ).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: topicsBloc.topics.length,
              itemBuilder: (context, index) {
                final topic = topicsBloc.topics.elementAt(index);
                return FTile(
                  title: topic.name.text(),
                  subtitle: Column(
                    children: [
                      topic.description.text(),
                      topic.chapter.name.text(),
                    ],
                  ),
                  onPress: () {
                    topicsBloc.gotoTopicViewPage(topic);
                  },
                  details: FButton.icon(
                    onPress: () {
                      topicsBloc.gotoEditTopicPage(topic);
                    },
                    child: FIcon(FAssets.icons.trophy),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      footer: FButton(
        onPress: addTopicBloc.openDialog,
        label: Icon(Icons.add),
      ).pad(),
    );
  }
}
