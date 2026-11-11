import 'dart:async';

import 'package:doctor_on_duty/domain/models/duty.dart';
import 'package:doctor_on_duty/domain/models/duty_day_override.dart';
import 'package:doctor_on_duty/domain/models/duty_slot.dart';
import 'package:doctor_on_duty/domain/services/store_service.dart';
import 'package:flutter/foundation.dart';

class DutiesRepository extends ChangeNotifier {
  DutiesRepository(this._store) {
    _dutySub = _store.watchAll<Duty>().listen((duties) {
      _duties = List<Duty>.from(duties);
      notifyListeners();
    });
    _slotSub = _store.watchAll<DutySlot>().listen((slots) {
      _slots = List<DutySlot>.from(slots);
      notifyListeners();
    });
    _overrideSub = _store.watchAll<DutyDayOverride>().listen((items) {
      _overrides = List<DutyDayOverride>.from(items);
      notifyListeners();
    });
  }

  final StoreService _store;
  StreamSubscription<List<Duty>>? _dutySub;
  StreamSubscription<List<DutySlot>>? _slotSub;
  StreamSubscription<List<DutyDayOverride>>? _overrideSub;
  List<Duty> _duties = [];
  List<DutySlot> _slots = [];
  List<DutyDayOverride> _overrides = [];

  List<Duty> get duties => List<Duty>.unmodifiable(_duties);
  List<DutySlot> get slots => List<DutySlot>.unmodifiable(_slots);
  List<DutyDayOverride> get dayOverrides =>
      List<DutyDayOverride>.unmodifiable(_overrides);

  int saveDuty(Duty duty) => _store.put(duty);

  void removeDuty(int id) => _store.remove<Duty>(id);

  void saveSlot(DutySlot slot) => _store.put(slot);

  void removeSlot(int id) => _store.remove<DutySlot>(id);

  void saveDayOverride(DutyDayOverride entry) => _store.put(entry);

  void removeDayOverride(int id) => _store.remove<DutyDayOverride>(id);

  Duty? dutyById(int id) {
    for (final d in _duties) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  void dispose() {
    _dutySub?.cancel();
    _slotSub?.cancel();
    _overrideSub?.cancel();
    super.dispose();
  }
}
