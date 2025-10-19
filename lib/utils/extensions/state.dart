import 'dart:async';

import 'package:flutter/material.dart' as material;

import '../repositories.dart';

abstract class State<W extends material.StatefulWidget> = material.State<W>
    with _State<W>;

mixin _State<W extends material.StatefulWidget> on material.State<W> {
  final subscriptions = <StreamSubscription>[];
  T watch<T extends Repository>() {
    final instance = repositories[T] as T;
    final subscription = instance.watch.listen(rebuild);
    subscriptions.add(subscription);
    return instance;
  }

  void rebuild([void _]) {
    setState(() {});
  }

  @override
  void dispose() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    super.dispose();
  }
}
