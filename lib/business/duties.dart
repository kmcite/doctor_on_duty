import 'package:doctor_on_duty/domain/duty_schedule.dart';
import 'package:doctor_on_duty/domain/models/duty.dart';
import 'package:doctor_on_duty/domain/models/duty_slot.dart';
import 'package:doctor_on_duty/domain/repositories/duties.dart';
import 'package:doctor_on_duty/domain/repositories/patients_repository.dart';
import 'package:flutter/foundation.dart';

class DutiesController extends ChangeNotifier {
  DutiesController(this._repository, this._patientsRepository) {
    _repository.addListener(_onRepoChanged);
    _patientsRepository.addListener(_onRepoChanged);
  }

  final DutiesRepository _repository;
  final PatientsRepository _patientsRepository;

  List<Duty> get duties => _repository.duties;
  List<DutySlot> get weeklySlots => _repository.slots;

  bool get hasWeeklySchedule => weeklySlots.isNotEmpty;

  DateTime get _now => DateTime.now();

  DutySlot? get activeSlot => DutySchedule.activeSlot(weeklySlots, _now);

  bool get isOnDuty => activeSlot != null;

  /// Open [Duty] for the currently active shift window, if any.
  Duty? get _openSessionForActiveSlot {
    final slot = activeSlot;
    if (slot == null) return null;
    final anchor = DutySchedule.anchorDayForSlot(slot, _now);
    final windowStart = DutySchedule.startOnDate(slot, anchor);
    final windowEnd = DutySchedule.endOnDate(slot, anchor);

    for (final duty in duties) {
      if (duty.isEnded) continue;
      final started = duty.startTime ?? duty.date;
      if (!started.isBefore(windowStart) && started.isBefore(windowEnd)) {
        return duty;
      }
    }
    return null;
  }

  Duty? get currentSession => _openSessionForActiveSlot;

  int patientCountForDuty(int dutyId) =>
      _patientsRepository.countForDuty(dutyId);

  int get patientsThisDuty {
    if (!isOnDuty) return 0;
    final session = _openSessionForActiveSlot;
    if (session == null || session.id == 0) return 0;
    return patientCountForDuty(session.id);
  }

  Duration? get remainingInDuty {
    final slot = activeSlot;
    if (slot == null) return null;
    return DutySchedule.remainingInSlot(slot, _now);
  }

  DateTime? get nextDutyStart {
    if (activeSlot != null) return null;
    return DutySchedule.nextStartAfter(weeklySlots, _now);
  }

  Duration? get timeUntilNextDuty {
    final next = nextDutyStart;
    if (next == null) return null;
    final remaining = next.difference(_now);
    if (remaining.isNegative) return Duration.zero;
    return remaining;
  }

  /// 1 → full wait ahead; 0 → next shift imminently (off duty only).
  double? get offDutyRemainingFraction {
    if (isOnDuty) return null;
    final next = nextDutyStart;
    if (next == null) return null;
    return DutySchedule.offDutyRemainingFraction(weeklySlots, _now, next);
  }

  List<Duty> get today {
    final now = _now;
    return duties.where((duty) => _isSameDay(duty.date, now)).toList();
  }

  List<Duty> get thisWeek {
    final now = _now;
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return duties.where((duty) {
      return duty.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          duty.date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
  }

  /// Ensures a [Duty] row exists for the active M/E/N shift.
  Duty ensureTodaySession() {
    final existing = _openSessionForActiveSlot;
    if (existing != null) return existing;

    final slot = activeSlot;
    final now = _now;
    if (slot == null) {
      final duty = Duty(
        date: DateTime(now.year, now.month, now.day),
        startTime: now,
      );
      final id = _repository.saveDuty(duty);
      duty.id = id;
      return duty;
    }

    final anchor = DutySchedule.anchorDayForSlot(slot, now);
    final scheduledStart = DutySchedule.startOnDate(slot, anchor);
    final duty = Duty(
      date: DateTime(anchor.year, anchor.month, anchor.day),
      startTime: scheduledStart.isBefore(now) ? now : scheduledStart,
    );
    final id = _repository.saveDuty(duty);
    duty.id = id;
    return duty;
  }

  void endTodaySession({String? notes}) {
    final session = _openSessionForActiveSlot;
    if (session == null) return;
    session.endTime = _now;
    if (notes != null && notes.isNotEmpty) {
      session.notes = notes;
    }
    _repository.saveDuty(session);
    notifyListeners();
  }

  void saveSlot(DutySlot slot) {
    _repository.saveSlot(slot);
  }

  void removeSlot(int id) => _repository.removeSlot(id);

  void saveDuty(Duty duty) => _repository.saveDuty(duty);

  void removeDuty(int id) => _repository.removeDuty(id);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _onRepoChanged() => notifyListeners();

  @override
  void dispose() {
    _repository.removeListener(_onRepoChanged);
    _patientsRepository.removeListener(_onRepoChanged);
    super.dispose();
  }
}
