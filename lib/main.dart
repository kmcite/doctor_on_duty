import 'package:doctor_on_duty/navigation/navigation_repository.dart';
import 'package:forui/forui.dart';
import 'package:manager/collection.dart';
export 'package:manager/database.dart';

import 'main.dart';
import 'topics/topics_page.dart';

export 'dart:io';
export 'package:colornames/colornames.dart';
export 'package:doctor_on_duty/chapters/chapters_page.dart';
export 'package:doctor_on_duty/settings/settings.dart';
export 'package:flutter/material.dart' hide Action;
export 'package:google_fonts/google_fonts.dart';
export 'package:path_provider/path_provider.dart';
export 'package:manager/manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Model.initialize().then(
    (_) async {
      runApp(const App());
    },
  );
}

final AppBloc appBloc = AppBloc();

class AppBloc {
  GlobalKey<NavigatorState> get key => navigationRepository.key;
}

class App extends UI {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appBloc.key,
      home: TopicsPage(),
      builder: (context, child) {
        return FTheme(
          data: switch (settingsBloc.themeMode()) {
            ThemeMode.light => FThemes.green.light,
            _ => FThemes.green.dark
          },
          child: child!,
        );
      },
      themeMode: settingsBloc.themeMode(),
    );
  }
}
