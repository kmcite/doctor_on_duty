import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/domain/models/case.dart';
import 'package:doctor_on_duty/main.dart';

final cazeRM = RM.inject<Caze>(() => throw UnimplementedError());

class CazePage extends UI {
  final Caze caze;
  const CazePage({super.key, required this.caze});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.x),
          ),
        ],
        title: Text(caze.name),
      ),
      child: Center(
        child: Text(caze.description),
      ),
    );
  }
}
