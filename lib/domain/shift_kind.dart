import 'package:doctor_on_duty/domain/models/duty_slot.dart';

/// Hospital shifts: M 08:00–14:00, E 14:00–20:00, N 20:00–08:00 (+1 day).
abstract final class ShiftKind {
  static const morning = 'm';
  static const evening = 'e';
  static const night = 'n';

  static const all = [morning, evening, night];

  static const morningStart = 8 * 60;
  static const morningEnd = 14 * 60;
  static const eveningStart = 14 * 60;
  static const eveningEnd = 20 * 60;
  static const nightStart = 20 * 60;
  static const nightEnd = 8 * 60;

  static String label(String kind) => switch (kind) {
        morning => 'Morning (M)',
        evening => 'Evening (E)',
        night => 'Night (N)',
        _ => kind,
      };

  static String shortLabel(String kind) => switch (kind) {
        morning => 'M',
        evening => 'E',
        night => 'N',
        _ => kind.toUpperCase(),
      };

  static String timeRangeLabel(String kind) => switch (kind) {
        morning => '08:00 – 14:00',
        evening => '14:00 – 20:00',
        night => '20:00 – 08:00',
        _ => '',
      };

  static (int startMinute, int endMinute) minutes(String kind) =>
      switch (kind) {
        morning => (morningStart, morningEnd),
        evening => (eveningStart, eveningEnd),
        night => (nightStart, nightEnd),
        _ => (morningStart, morningEnd),
      };

  static bool isOvernight(String kind) => kind == night;

  /// Reads [DutySlot.shiftKind] or infers from stored minutes.
  static String resolve(DutySlot slot) {
    if (all.contains(slot.shiftKind)) {
      final (s, e) = minutes(slot.shiftKind);
      if (slot.startMinute == s && slot.endMinute == e) {
        return slot.shiftKind;
      }
    }
    return inferFromMinutes(slot.startMinute, slot.endMinute) ?? slot.shiftKind;
  }

  static String? inferFromMinutes(int start, int end) {
    if (start == morningStart && end == morningEnd) return morning;
    if (start == eveningStart && end == eveningEnd) return evening;
    if (start == nightStart && end == nightEnd) return night;
    return null;
  }

  static DutySlot slotFor({
    required int weekday,
    required String kind,
  }) {
    final (start, end) = minutes(kind);
    return DutySlot(
      weekday: weekday,
      startMinute: start,
      endMinute: end,
      shiftKind: kind,
      label: label(kind),
    );
  }
}
