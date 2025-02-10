import '../main.dart';

final SettingsBloc settingsBloc = SettingsBloc();

class SettingsBloc {
  final settingsRM = RM.inject(() => Settings());
  Settings settings([_]) {
    if (_ != null) settingsRM.state = _;
    return settingsRM.state;
  }

  ThemeMode themeMode([ThemeMode? value]) {
    if (value != null) {
      settingsRM
        ..state = (settings()..themeMode = value)
        ..notify();
    }
    return settings().themeMode;
  }
}

class Settings {
  MaterialColor materialColor = Colors.blue;
  ThemeMode themeMode = ThemeMode.system;
  Font font = Font.operatorMono;
  double padding = 8.0;
  double borderRadius = 8.0;
}

enum Font {
  azeretMono('Azeret Mono'),
  comfortaa('Comfortaa'),
  operatorMono('Operator Mono'),
  lotion('Lotion'),
  dMMono('DM Mono'),
  dosis('Dosis'),
  firaSans('Fira Sans'),
  iBMPlexMono('IBM Plex Mono'),
  josefinSans('Josefin Sans'),
  montserrat('Montserrat'),
  spaceMono('Space Mono'),
  ubuntu('Ubuntu'),
  defaultFont(null);

  const Font([this.description = null]);
  final String? description;
}
