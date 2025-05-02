import 'dart:async';

import 'package:doctor_on_duty/domain/api/settings_repository.dart';
import 'package:doctor_on_duty/objectbox.g.dart';
import 'package:doctor_on_duty/ui/hub.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';
export 'package:forui/forui.dart';

import 'main.dart';

export 'dart:io';
export 'package:colornames/colornames.dart';
export 'package:doctor_on_duty/ui/cases/chapters_page.dart';
export 'package:flutter/material.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:path_provider/path_provider.dart';
export 'package:manager/manager.dart';
export 'package:states_rebuilder/states_rebuilder.dart';

late final Store store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = await openStore();
  runApp(App());
}

final _appBloc = AppBloc();

class AppBloc extends Bloc<void, bool> {
  StreamSubscription? _subscription;
  AppBloc() : super() {
    _subscription = settingsRepository().listen(emit);
  }
  @override
  bool get initialState => settingsRepository.value;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class App extends UI {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.key,
      builder: (context, child) {
        return FTheme(
          data: switch (_appBloc()) {
            false => FThemes.yellow.light,
            true => FThemes.yellow.dark,
          },
          child: child!,
        );
      },
      themeMode: _appBloc() ? ThemeMode.dark : ThemeMode.light,
      home: Hub(),
    );
  }
}

typedef UI = ReactiveStatelessWidget;
