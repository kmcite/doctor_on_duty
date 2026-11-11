import 'package:doctor_on_duty/domain/shift_kind.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:flutter/material.dart';

/// Shared M / E / N colors and toggle styling.
abstract final class ShiftUi {
  static Color accent(BuildContext context, String kind) => switch (kind) {
        ShiftKind.morning => AppColors.onDuty,
        ShiftKind.evening => AppColors.opd,
        ShiftKind.night => const Color(0xFF7C3AED),
        _ => Theme.of(context).colorScheme.primary,
      };

  static int totalSelected(Map<int, Set<String>> byDay) =>
      byDay.values.fold(0, (sum, set) => sum + set.length);
}

/// Tap to toggle one shift on a day (or anywhere).
class ShiftToggle extends StatelessWidget {
  const ShiftToggle({
    super.key,
    required this.kind,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final String kind;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = ShiftUi.accent(context, kind);
    final label = compact
        ? ShiftKind.shortLabel(kind)
        : ShiftKind.shortLabel(kind);

    final borderRadius = LiquidGlass.borderRadius(AppRadii.sm);
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: ShiftKind.label(kind),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: selected
              ? LiquidGlass.insetFill(context, color)
              : LiquidGlass.panelGradientTop(Theme.of(context).brightness),
          border: Border.all(
            color: selected
                ? color
                : LiquidGlass.borderColor(context),
            width: selected ? 1.5 : 1.1,
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              splashColor: color.withValues(alpha: 0.18),
              highlightColor: color.withValues(alpha: 0.08),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: compact ? 10 : 12,
                  horizontal: compact ? 8 : 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 15 : 16,
                        color: selected ? color : scheme.onSurface,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 2),
                      Text(
                        _shortTime(kind),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? color
                                  : LiquidGlass.textTertiary(context),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _shortTime(String kind) => switch (kind) {
        ShiftKind.morning => '8–2',
        ShiftKind.evening => '2–8',
        ShiftKind.night => '8–8',
        _ => '',
      };
}
