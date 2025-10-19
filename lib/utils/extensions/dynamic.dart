import 'package:flutter/widgets.dart';

extension DynamicExtension on dynamic {
  Widget text() => Text(
        toString(),
      );
}
