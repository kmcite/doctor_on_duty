import 'package:objectbox/objectbox.dart';

import 'model.dart';

/// One recurring M/E/N shift on a weekday (see [ShiftKind]).
@Entity()
class DutySlot extends Model {
  @override
  @Id()
  int id = 0;

  /// [DateTime.monday] … [DateTime.sunday] (1–7).
  int weekday = DateTime.monday;

  /// Minutes from midnight [0, 1439].
  int startMinute = 8 * 60;

  /// End minute; if less than [startMinute], shift ends the next calendar day.
  int endMinute = 16 * 60;

  String label = '';

  /// One of [ShiftKind.morning], [ShiftKind.evening], [ShiftKind.night] (`m`/`e`/`n`).
  String shiftKind = 'm';

  DutySlot({
    this.weekday = DateTime.monday,
    this.startMinute = 8 * 60,
    this.endMinute = 14 * 60,
    this.label = '',
    this.shiftKind = 'm',
  });
}
