import 'package:doctor_on_duty/navigation/navigation_repository.dart';

final navigator = NavigationBloc();

class NavigationBloc {
  late final to = navigationRepository.navigator.to;
  late final back = navigationRepository.navigator.back;
  late final toDialog = navigationRepository.navigator.toDialog;
}
