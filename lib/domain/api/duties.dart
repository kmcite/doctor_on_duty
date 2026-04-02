import 'dart:async';

import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/store.dart';

class Duties {
  List<Duty> duties = [];
  Duty? activeDuty;
  DateTime? dutyStartTime;

  /// DERIVED STATE
  Duration? get dutyDuration =>
      dutyStartTime != null ? DateTime.now().difference(dutyStartTime!) : null;
  bool get isOnDuty => activeDuty != null;
  Iterable<Duty> get today {
    final now = DateTime.now();
    return duties.where((duty) {
      return duty.date.year == now.year &&
          duty.date.month == now.month &&
          duty.date.day == now.day;
    });
  }

  Iterable<Duty> get thisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return duties.where(
      (duty) {
        return duty.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            duty.date.isBefore(weekEnd.add(const Duration(days: 1)));
      },
    );
  }

  Duty? get currentDuty {
    // Check if there's a duty for today that might be active
    final today = DateTime.now();
    final todayDuties = duties
        .where(
          (duty) =>
              duty.date.year == today.year &&
              duty.date.month == today.month &&
              duty.date.day == today.day &&
              !duty.isEnded,
        )
        .toList();
    return todayDuties.isNotEmpty ? todayDuties.last : null;
  }
}

Duties duties(Duties state, action) {
  return switch (action) {
    SubscribeToDuties() => state,
    UnsubscribeFromDuties() => state..duties = [],
    RefreshDuties() => state..duties = action.duties,
    StartDuty() => state..dutyStartTime = action.startTime,
    EndDuty() => state..dutyStartTime = null,
    ActiveDuty() => state..activeDuty = action.duty,
    DutyStartTime() => state..dutyStartTime = action.startTime,
    _ => state,
  };
}

class DutiesAction {
  const DutiesAction();
}

class SubscribeToDuties extends DutiesAction {}

class UnsubscribeFromDuties extends DutiesAction {}

class RefreshDuties extends DutiesAction {
  final List<Duty> duties;
  const RefreshDuties(this.duties);
}

class StartDuty extends DutiesAction {
  final DateTime startTime;
  const StartDuty(this.startTime);
}

class EndDuty extends DutiesAction {}

class ActiveDuty extends DutiesAction {
  final Duty? duty;
  const ActiveDuty(this.duty);
}

class DutyStartTime extends DutiesAction {
  final DateTime? startTime;
  const DutyStartTime(this.startTime);
}

StreamSubscription? _dutiesSubscription;
void dutiesMW(dynamic action) {
  if (action is SubscribeToDuties) {
    _dutiesSubscription = store.state.store
        .box<Duty>()
        .query()
        .watch(triggerImmediately: true)
        .listen((query) {
          apply(RefreshDuties(query.find()));
        });
  } else if (action is UnsubscribeFromDuties) {
    _dutiesSubscription?.cancel();
    _dutiesSubscription = null;
  }
  if (action is StartDuty) {
    final now = DateTime.now();
    apply(
      ActiveDuty(
        Duty(
          date: DateTime(
            now.year,
            now.month,
            now.day,
          ), // Normalize to start of day
          startTime: action.startTime,
        ),
      ),
    );
    apply(DutyStartTime(action.startTime));

    // Save to database
    apply(Put(store.state.duties.activeDuty!));
  }
  if (action is EndDuty) {
    if (store.state.duties.activeDuty != null) {
      // Update endTime when duty ends
      apply(
        Put(
          store.state.duties.activeDuty!..endTime = DateTime.now(),
        ),
      );
      // Clear active duty
      apply(ActiveDuty(null));
      apply(DutyStartTime(null));
    }
  }
}
