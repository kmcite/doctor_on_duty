import 'package:doctor_on_duty/main.dart';

final navigationRepository = NavigationRepository();

class NavigationRepository {
  GlobalKey<NavigatorState> get key => navigator.navigatorKey;

  final navigator = RM.navigate;

  late final to = navigator.to;
  late final back = navigator.back;
  late final toDialog = navigator.toDialog;
}
