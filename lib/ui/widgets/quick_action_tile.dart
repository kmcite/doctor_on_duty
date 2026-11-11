import 'package:flutter/material.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_panel.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LiquidPanel(
      onTap: onTap,
      tint: color,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: LiquidGlass.bodySecondary(context),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: LiquidGlass.textTertiary(context),
          ),
        ],
      ),
    );
  }
}
