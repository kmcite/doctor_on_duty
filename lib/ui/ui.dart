import 'package:doctor_on_duty/domain/state_tree.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

abstract class UI extends StatefulWidget {
  const UI({super.key});
  Widget build(BuildContext context);
  void init() {}
  void dispose() {}

  @override
  State<UI> createState() => _UIState();

  StateTree get state => store.state;
}

class _UIState extends State<UI> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<StateTree>(
      builder: (context, _) => OnReactive(() => widget.build(context)),
      onInit: (_) => widget.init(),
      onDispose: (_) => widget.dispose(),
    );
  }
}
