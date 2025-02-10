import 'package:doctor_on_duty/navigation/navigator.dart';
import 'package:forui/forui.dart';

import '../main.dart';

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'settings'.text(),
        actions: [
          FHeaderAction.back(
            onPress: navigator.back,
          ),
        ],
      ),
      content: ListView(
        children: [
          FTileGroup(
            children: ThemeMode.values.map(
              (themeMode) {
                return FTile(
                  suffixIcon: settingsBloc.themeMode() == themeMode
                      ? FIcon(FAssets.icons.check)
                      : null,
                  title: themeMode.name.toUpperCase().text(),
                  onPress: () => settingsBloc.themeMode(themeMode),
                );
              },
            ).toList(),
            label: FTile(
              title: settingsBloc.themeMode().name.toUpperCase().text(),
            ),
          ),
        ],
      ),
    );
  }
}
