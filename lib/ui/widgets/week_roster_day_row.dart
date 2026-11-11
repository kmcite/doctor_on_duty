import 'package:doctor_on_duty/domain/duty_schedule.dart';
import 'package:doctor_on_duty/domain/shift_kind.dart';
import 'package:doctor_on_duty/ui/shift_ui.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:flutter/material.dart';

class WeekRosterDayRow extends StatelessWidget {
  const WeekRosterDayRow({
    super.key,
    required this.weekday,
    required this.selected,
    required this.onToggle,
    this.muted = false,
    this.highlight = false,
    this.enabled = true,
  });

  final int weekday;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final bool muted;
  final bool highlight;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: muted
              ? LiquidGlass.textTertiary(context)
              : highlight
                  ? scheme.primary
                  : LiquidGlass.textPrimary(context),
        );

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              DutySchedule.weekdayLabel(weekday),
              style: labelStyle,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < ShiftKind.all.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
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
          ),
        ],
      ),
    );
    if (!enabled) {
      return Opacity(opacity: 0.45, child: IgnorePointer(child: row));
    }
    return row;
  }
}
