import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/ui/hub/hub.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:forui/forui.dart';

import 'main.dart';
import 'ui/ui.dart';

export 'dart:io';
export 'package:colornames/colornames.dart';
export 'package:flutter/material.dart' hide State;
export 'package:google_fonts/google_fonts.dart';
export 'package:path_provider/path_provider.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:doctor_on_duty/utils/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    StoreProvider(store: store, child: App()),
  );
}

class App extends UI {
  const App({super.key});

  @override
  void init() {
    apply(StoreIsLoading());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator,
      theme: FThemes.green.light.toApproximateMaterialTheme(),
      darkTheme: FThemes.red.dark.toApproximateMaterialTheme(),
      builder: (context, child) => FTheme(
        data: state.dark ? FThemes.red.dark : FThemes.green.light,
        child: child!,
      ),
      themeMode: state.dark ? .dark : .light,
      themeAnimationDuration: Durations.long2,
      home: state.isStoreWaiting
          ? Center(child: FCircularProgress.loader())
          : Hub(),
    );
  }
}
