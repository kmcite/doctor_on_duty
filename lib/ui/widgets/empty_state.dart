import 'package:flutter/material.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: LiquidGlass.textTertiary(context), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: LiquidGlass.bodySecondary(context),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
