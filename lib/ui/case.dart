import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/domain/models/case.dart';
import 'package:doctor_on_duty/main.dart';

final cazeRM = RM.inject<Caze>(() => throw UnimplementedError());

class CazePage extends StatefulWidget {
  final Caze caze;
  const CazePage({required this.caze});

  @override
  State<CazePage> createState() => _CazePageState();
}

class _CazePageState extends State<CazePage> {
  late Caze caze = widget.caze;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.x),
            onPress: navigator.back,
          ),
        ],
        title: Text(widget.caze.name),
      ),
      child: Center(
        child: Text(widget.caze.description),
      ),
    );
  }
}
