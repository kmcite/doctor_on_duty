import 'package:doctor_on_duty/domain/store.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

final navigator = GlobalKey<NavigatorState>();

void navigationMW(dynamic action) async {
  switch (action) {
    case NavigateBack():
      navigator.currentState?.pop();
      break;

    case NavigateTo():
      await navigator.currentState?.push(
        MaterialPageRoute(builder: action.builder),
      );
      break;
    case ShowDialog():
      await showFDialog(
        context: navigator.currentContext!,
        builder: action.builder,
      );
      break;
    case ShowBottomSheet():
      final controller = showFPersistentSheet(
        context: navigator.currentContext!,
        side: action.side,
        builder: action.builder,
      );
      apply(ResultOfBottomSheet(controller));
      break;
    default:
      break;
  }
}

sealed class NavigationAction {
  const NavigationAction();
}

class NavigateBack extends NavigationAction {
  const NavigateBack();
}

class NavigateTo<W extends Widget> extends NavigationAction {
  final W Function(BuildContext context) builder;
  const NavigateTo(this.builder);
}

class ShowDialog<D extends Widget> extends NavigationAction {
  final Widget Function(
    BuildContext context,
    FDialogStyle style,
    Animation<double> animation,
  )
  builder;
  const ShowDialog(this.builder);
}

class ShowBottomSheet<D extends Widget> extends NavigationAction {
  final D Function(BuildContext context, FPersistentSheetController controller)
  builder;
  final FLayout side;
  const ShowBottomSheet(this.builder, this.side);
}

class ResultOfBottomSheet extends NavigationAction {
  final FPersistentSheetController result;
  const ResultOfBottomSheet(this.result);
}
