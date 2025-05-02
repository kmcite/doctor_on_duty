import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/cases/cases.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import 'settings.dart';

class Hub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text("Doctor on Duty").pad(),
        actions: [
          FButton.icon(
            child: FIcon(FAssets.icons.settings),
            onPress: () => navigator.to(SettingsPage()),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 12,
            children: [
              FTile(
                title: Text("Cases"),
                onPress: () {
                  navigator.to(CasesPage());
                },
              ),
              FTile(
                title: Text("Emergency"),
                onPress: () {},
              ),
              FTile(
                title: Text("Search"),
                onPress: () {},
              ),
              FTile(
                title: Text("Favorites"),
                onPress: () {},
              ),
            ],
          ),
          SizedBox(height: 16),
          RecentlyAddedCases(), // Custom widget
          RecentlyViewedCases(), // Optional
          CaseOfTheDay(),
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
