import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/cases/cases.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/ui/search_symptoms.dart';

import 'settings.dart';

class Hub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text("HealthCare +").pad(),
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.settings),
            onPress: () => navigator.to(SettingsPage()),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 12,
            children: [
              FTile(
                prefix: Icon(FIcons.info),
                title: Text("Cases"),
                onPress: () {
                  navigator.to(CasesPage());
                },
              ),
              FTile(
                prefix: Icon(FIcons.ambulance),
                title: Text("Emergency"),
                onPress: () {},
              ),
              FTile(
                prefix: Icon(FIcons.search),
                title: Text("Search"),
                onPress: () {
                  navigator.to(SearchSymptomPage());
                },
              ),
              FTile(
                prefix: Icon(FIcons.heartPulse),
                title: Text("Favorites"),
                onPress: () {},
              ),
              FTile(title: RecentlyAddedCases()), // Custom widget
              FTile(title: RecentlyViewedCases()), // Optional
              FTile(title: CaseOfTheDay()),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentlyAddedCases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text("Recently Added Cases"),
    );
  }
}

class RecentlyViewedCases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text("Recently Viewed Cases"),
    );
  }
}

class CaseOfTheDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text("Case of the Day"),
    );
  }
}
