import 'package:doctor_on_duty/domain/models/duty_slot.dart';
import 'package:doctor_on_duty/domain/shift_kind.dart';

/// Pure schedule math (no Flutter).
abstract final class DutySchedule {
  static DateTime startOnDate(DutySlot slot, DateTime day) {
    final base = DateTime(day.year, day.month, day.day);
    return base.add(Duration(minutes: slot.startMinute));
  }

  static DateTime endOnDate(DutySlot slot, DateTime day) {
    final base = DateTime(day.year, day.month, day.day);
    var end = base.add(Duration(minutes: slot.endMinute));
    if (slot.endMinute <= slot.startMinute) {
      end = end.add(const Duration(days: 1));
    }
    return end;
  }

  static bool _isOvernight(DutySlot slot) => slot.endMinute <= slot.startMinute;

  /// Calendar day the shift *starts* on, for a given [now] inside that shift.
  static DateTime anchorDayForSlot(DutySlot slot, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (now.weekday == slot.weekday) return today;
    if (_isOvernight(slot)) {
      final yesterday = today.subtract(const Duration(days: 1));
      if (yesterday.weekday == slot.weekday) {
        final start = startOnDate(slot, yesterday);
        final end = endOnDate(slot, yesterday);
        if (!now.isBefore(start) && now.isBefore(end)) return yesterday;
      }
    }
    return today;
  }

  /// Whether [now] falls inside this slot's window.
  static bool isActiveAt(DutySlot slot, DateTime now) {
    final anchor = anchorDayForSlot(slot, now);
    if (anchor.weekday != slot.weekday) return false;
    final start = startOnDate(slot, anchor);
    final end = endOnDate(slot, anchor);
    return !now.isBefore(start) && now.isBefore(end);
  }

  static String slotTitle(DutySlot slot) {
    final kind = ShiftKind.resolve(slot);
    return '${DutySchedule.weekdayLabel(slot.weekday)} · '
        '${ShiftKind.shortLabel(kind)} · ${ShiftKind.timeRangeLabel(kind)}';
  }

  /// End of the most recent shift window at or before [from].
  static DateTime? lastShiftEndBefore(List<DutySlot> slots, DateTime from) {
    if (slots.isEmpty) return null;

    DateTime? best;
    for (var d = -7; d <= 0; d++) {
      final day = DateTime(
        from.year,
        from.month,
        from.day,
      ).add(Duration(days: d));
      for (final slot in slots) {
        if (day.weekday != slot.weekday) continue;
        final end = endOnDate(slot, day);
        if (end.isAfter(from)) continue;
        if (best == null || end.isAfter(best)) {
          best = end;
        }
      }
    }
    return best;
  }

  /// Share of off-duty wait still remaining (1 = full wait, 0 = shift starting).
  static double? offDutyRemainingFraction(
    List<DutySlot> slots,
    DateTime now,
    DateTime nextStart,
  ) {
    final lastEnd = lastShiftEndBefore(slots, now);
    final windowStart = lastEnd ?? now;
    final total = nextStart.difference(windowStart);
    if (total.inSeconds <= 0) return null;
    final remaining = nextStart.difference(now);
    if (remaining.isNegative) return 0;
    return (remaining.inSeconds / total.inSeconds).clamp(0.0, 1.0);
  }

  /// Next shift start strictly after [from].
  static DateTime? nextStartAfter(List<DutySlot> slots, DateTime from) {
    if (slots.isEmpty) return null;

    DateTime? best;
    for (var d = 0; d < 8; d++) {
      final day = DateTime(
        from.year,
        from.month,
        from.day,
      ).add(Duration(days: d));
      for (final slot in slots) {
        if (day.weekday != slot.weekday) continue;
        final start = startOnDate(slot, day);
        if (!start.isAfter(from)) continue;
        if (best == null || start.isBefore(best)) {
          best = start;
        }
      }
    }
    return best;
  }

  static DutySlot? activeSlot(List<DutySlot> slots, DateTime now) {
    for (final slot in slots) {
      if (isActiveAt(slot, now)) return slot;
    }
    return null;
  }

  static Duration? remainingInSlot(DutySlot slot, DateTime now) {
    if (!isActiveAt(slot, now)) return null;
    final anchor = anchorDayForSlot(slot, now);
    final end = endOnDate(slot, anchor);
    return end.difference(now);
  }

  static String weekdayLabel(int weekday, {bool full = false}) {
    const short = [
      '',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    const long = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return full ? long[weekday] : short[weekday];
  }

  static String formatMinutes(int totalMinutes) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static String formatDuration(Duration d) {
    if (d.isNegative) return '0m';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}
