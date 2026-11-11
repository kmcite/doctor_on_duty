import 'package:flutter/material.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_buttons.dart';

/// Frosted-style panel using layered opacity — no backdrop blur.
class LiquidPanel extends StatelessWidget {
  const LiquidPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius,
    this.tint,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? radius;
  final Color? tint;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? AppRadii.liquid;
    final borderRadius = LiquidGlass.borderRadius(r);
    final scheme = Theme.of(context).colorScheme;

    final panelBody = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LiquidGlass.panelFillTop(context, tint: tint),
            LiquidGlass.panelFillBottom(context, tint: tint),
          ],
        ),
        border: Border.all(
          color: LiquidGlass.borderColor(context),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: onTap != null
            ? Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: borderRadius,
                  splashColor: scheme.primary.withValues(alpha: 0.12),
                  highlightColor: scheme.primary.withValues(alpha: 0.06),
                  child: Padding(padding: padding, child: child),
                ),
              )
            : Padding(padding: padding, child: child),
      ),
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: LiquidGlass.shadow(context),
      ),
      child: panelBody,
    );
  }
}

/// Smaller tinted inset inside a panel (shift status, stat chips).
class LiquidInset extends StatelessWidget {
  const LiquidInset({
    super.key,
    required this.child,
    required this.accent,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final Color accent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = LiquidGlass.borderRadius(AppRadii.md);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: LiquidGlass.insetFill(context, accent),
        borderRadius: borderRadius,
        border: Border.all(
          color: LiquidGlass.insetBorder(accent, Theme.of(context).brightness),
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class LiquidFab extends StatelessWidget {
  const LiquidFab({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = LiquidGlass.primaryActionFill(
      scheme,
      Theme.of(context).brightness,
    );

    return LiquidTapShell(
      onPressed: onPressed,
      borderRadius: LiquidGlass.borderRadius(AppRadii.pill),
      fillTop: fill,
      fillBottom: LiquidGlass.primaryActionFillBottom(
        scheme,
        Theme.of(context).brightness,
      ),
      border: LiquidGlass.borderColor(context),
      shadows: LiquidGlass.shadow(context),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: scheme.onPrimary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
