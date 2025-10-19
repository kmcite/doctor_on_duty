import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final navigator = Navigation();

class Navigation {
  final navigate = RM.navigate;

  GlobalKey<NavigatorState> get key => navigate.navigatorKey;

  void to(Widget page) {
    navigate.to(page);
  }

  void back<T extends Object>([T? result]) => navigate.back(result);
  Future<T?> dialog<T>(Widget dialog) {
    return navigate.toDialog(dialog);
  }
}
