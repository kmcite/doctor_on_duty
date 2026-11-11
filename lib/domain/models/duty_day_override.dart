import 'package:objectbox/objectbox.dart';

import 'model.dart';

/// One-off calendar day with no scheduled shifts (e.g. leave).
@Entity()
class DutyDayOverride extends Model {
  @override
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  String note = '';

  DutyDayOverride({DateTime? date, this.note = ''})
      : date = date ?? DateTime.now();
}
