import 'package:doctor_on_duty/main.dart';

extension WidgetX on Widget {
  Widget pad() => Padding(
        padding: EdgeInsets.all(8),
        child: this,
      );
}
