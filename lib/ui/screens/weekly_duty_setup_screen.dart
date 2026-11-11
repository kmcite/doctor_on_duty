import 'package:doctor_on_duty/business/duties.dart';
import 'package:doctor_on_duty/domain/duty_schedule.dart';
import 'package:doctor_on_duty/domain/shift_kind.dart';
import 'package:doctor_on_duty/ui/shift_ui.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:doctor_on_duty/ui/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Repeating week roster: pick M / E / N per weekday.
class WeeklyDutySetupScreen extends StatefulWidget {
  const WeeklyDutySetupScreen({
    super.key,
    this.requiredSetup = false,
  });

  final bool requiredSetup;

  @override
  State<WeeklyDutySetupScreen> createState() => _WeeklyDutySetupScreenState();
}

class _WeeklyDutySetupScreenState extends State<WeeklyDutySetupScreen> {
  final Map<int, Set<String>> _selected = {
    for (var w = DateTime.monday; w <= DateTime.sunday; w++) w: {},
  };

  bool _loaded = false;

  int get _totalShifts => ShiftUi.totalSelected(_selected);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    for (final s in context.read<DutiesController>().weeklySlots) {
      _selected[s.weekday]!.add(ShiftKind.resolve(s));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return PopScope(
      canPop: !widget.requiredSetup,
      child: LiquidScaffold(
        appBar: AppBar(
          title: const Text('Week roster'),
          automaticallyImplyLeading: !widget.requiredSetup,
          actions: [
            PopupMenuButton<_WeekAction>(
              tooltip: 'Week actions',
              onSelected: _onWeekAction,
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: _WeekAction.copyMonAll,
                  child: Text('Use Monday for all days'),
                ),
                PopupMenuItem(
                  value: _WeekAction.copyMonWeekdays,
                  child: Text('Use Monday for Mon–Fri'),
                ),
                PopupMenuItem(
                  value: _WeekAction.clear,
                  child: Text('Clear week'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.sm,
                  AppSpacing.pageHorizontal,
                  AppSpacing.md,
                ),
                children: [
                  Text(
                    'Same pattern every week. Tap M, E, or N for each day.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.75),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...List.generate(7, (i) {
                    final weekday = i + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _DayRosterCard(
                        weekday: weekday,
                        selected: _selected[weekday]!,
                        onToggle: (kind) => _toggle(weekday, kind),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Material(
              elevation: 8,
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.md,
                    AppSpacing.pageHorizontal,
                    bottom > 0 ? 0 : AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _totalShifts == 0
                              ? 'No shifts selected'
                              : '$_totalShifts shift${_totalShifts == 1 ? '' : 's'} / week',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      FilledButton(
                        onPressed: _save,
                        child: Text(
                          widget.requiredSetup ? 'Continue' : 'Save',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle(int weekday, String kind) {
    setState(() {
      final set = _selected[weekday]!;
      if (set.contains(kind)) {
        set.remove(kind);
      } else {
        set.add(kind);
      }
    });
  }

  void _onWeekAction(_WeekAction action) {
    switch (action) {
      case _WeekAction.copyMonAll:
        final mon = Set<String>.from(_selected[DateTime.monday]!);
        setState(() {
          for (final w in _selected.keys) {
            _selected[w]!
              ..clear()
              ..addAll(mon);
          }
        });
      case _WeekAction.copyMonWeekdays:
        final mon = Set<String>.from(_selected[DateTime.monday]!);
        setState(() {
          for (var w = DateTime.monday; w <= DateTime.friday; w++) {
            _selected[w]!
              ..clear()
              ..addAll(mon);
          }
        });
      case _WeekAction.clear:
        setState(() {
          for (final s in _selected.values) {
            s.clear();
          }
        });
    }
  }

  void _save() {
    final ctrl = context.read<DutiesController>();
    for (final old in List.of(ctrl.weeklySlots)) {
      ctrl.removeSlot(old.id);
    }
    for (final entry in _selected.entries) {
      for (final kind in entry.value) {
        ctrl.saveSlot(ShiftKind.slotFor(weekday: entry.key, kind: kind));
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _totalShifts == 0
              ? 'Roster cleared'
              : 'Saved $_totalShifts shifts per week',
        ),
      ),
    );

    if (widget.requiredSetup) {
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      Navigator.pop(context);
    }
  }
}

enum _WeekAction { copyMonAll, copyMonWeekdays, clear }

class _DayRosterCard extends StatelessWidget {
  const _DayRosterCard({
    required this.weekday,
    required this.selected,
    required this.onToggle,
  });

  final int weekday;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final dayName = DutySchedule.weekdayLabel(weekday, full: true);
    final off = selected.isEmpty;

    return SectionCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dayName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (off)
                Text(
                  'Off',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.45),
                      ),
                )
              else
                Text(
                  '${selected.length} shift${selected.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var i = 0; i < ShiftKind.all.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ShiftToggle(
                    kind: ShiftKind.all[i],
                    selected: selected.contains(ShiftKind.all[i]),
                    onTap: () => onToggle(ShiftKind.all[i]),
                    compact: true,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
