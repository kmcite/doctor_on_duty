import 'package:doctor_on_duty/domain/reads/settings.dart';
import 'package:doctor_on_duty/objectbox.g.dart';
import 'package:doctor_on_duty/ui/hub.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
export 'package:forui/forui.dart';

import 'main.dart';
import 'utils/services.dart';

export 'package:doctor_on_duty/utils/extensions/ui.dart';
export 'dart:io';
export 'package:colornames/colornames.dart';
export 'package:doctor_on_duty/ui/cases/chapters.dart';
export 'package:flutter/material.dart' hide State;
export 'package:google_fonts/google_fonts.dart';
export 'package:path_provider/path_provider.dart';
// export 'package:manager/manager.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:doctor_on_duty/utils/extensions/dynamic.dart';
export 'package:doctor_on_duty/utils/extensions/widget.dart';
export 'package:doctor_on_duty/utils/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await getApplicationDocumentsDirectory();
  final appInfo = await PackageInfo.fromPlatform();
  final store = await openStore(
    directory: join(path.path, appInfo.packageName),
  );
  service(store);

  runApp(App());
}

class App extends UI {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.key,
      builder: (context, child) {
        return FTheme(
          data: switch (darkRead.state) {
            false => FThemes.yellow.light,
            true => FThemes.yellow.dark,
          },
          child: child!,
        );
      },
      themeMode: darkRead.state ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: Durations.long2,
      home: Hub(),
    );
  }
}
