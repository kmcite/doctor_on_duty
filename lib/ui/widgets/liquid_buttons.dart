import 'package:flutter/material.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';

/// Shared glassy tap targets (gradient fill, border, soft shadow).
abstract final class LiquidButtons {
  static BorderRadius get _radius => LiquidGlass.borderRadius(AppRadii.liquid);
  static BorderRadius get _chipRadius => LiquidGlass.borderRadius(AppRadii.md);

  static ButtonStyle filled(Brightness brightness, ColorScheme scheme) {
    final fill = LiquidGlass.primaryActionFill(scheme, brightness);
    return ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: _radius),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: LiquidGlass.borderColorFor(brightness)),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return fill.withValues(alpha: fill.a * 0.45);
        }
        return fill;
      }),
      foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  static ButtonStyle outlined(Brightness brightness, ColorScheme scheme) {
    return ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: _radius),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: LiquidGlass.borderColorFor(brightness), width: 1.2),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return LiquidGlass.panelGradientBottom(brightness);
        }
        return LiquidGlass.panelGradientTop(brightness);
      }),
      foregroundColor: WidgetStateProperty.all(scheme.primary),
    );
  }

  static ButtonStyle text(Brightness brightness, ColorScheme scheme) {
    return ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: _chipRadius),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withValues(alpha: 0.35);
        }
        return scheme.onSurface;
      }),
      overlayColor: WidgetStatePropertyAll(
        scheme.primary.withValues(alpha: 0.1),
      ),
    );
  }

  static ButtonStyle segmented(Brightness brightness, ColorScheme scheme) {
    final isDark = brightness == Brightness.dark;
    final border = LiquidGlass.borderColorFor(brightness);
    final panel = LiquidGlass.panelGradientTop(brightness);
    final selected = Color.alphaBlend(
      scheme.primary.withValues(alpha: isDark ? 0.28 : 0.16),
      LiquidGlass.panelGradientBottom(brightness),
    );
    return ButtonStyle(
      side: WidgetStateProperty.all(BorderSide(color: border, width: 1.1)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: _chipRadius),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return selected;
        if (states.contains(WidgetState.disabled)) {
          return LiquidGlass.panelGradientBottom(brightness);
        }
        return panel;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isDark ? scheme.primary : const Color(0xFF0F766E);
        }
        return scheme.onSurface;
      }),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w600,
        );
      }),
    );
  }
}

enum LiquidButtonVariant { primary, secondary, ghost, danger }

class LiquidButton extends StatelessWidget {
  const LiquidButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.variant = LiquidButtonVariant.primary,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final LiquidButtonVariant variant;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onPressed == null || loading;

    final primaryFill = LiquidGlass.primaryActionFill(scheme, Theme.of(context).brightness);
    final (fillTop, fillBottom, foreground, border) = switch (variant) {
      LiquidButtonVariant.primary => (
          primaryFill,
          LiquidGlass.primaryActionFillBottom(scheme, Theme.of(context).brightness),
          scheme.onPrimary,
          LiquidGlass.borderColor(context),
        ),
      LiquidButtonVariant.secondary => (
          LiquidGlass.panelFillTop(context),
          LiquidGlass.panelFillBottom(context),
          scheme.primary,
          LiquidGlass.borderColor(context),
        ),
      LiquidButtonVariant.ghost => (
          Colors.transparent,
          Colors.transparent,
          LiquidGlass.textPrimary(context),
          Colors.transparent,
        ),
      LiquidButtonVariant.danger => (
          AppColors.emergency,
          const Color(0xFFB91C1C),
          Colors.white,
          AppColors.emergency.withValues(alpha: 0.55),
        ),
    };

    final child = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          );

    return LiquidTapShell(
      onPressed: disabled ? null : onPressed,
      borderRadius: LiquidButtons._radius,
      fillTop: fillTop,
      fillBottom: fillBottom,
      border: border,
      shadows: variant == LiquidButtonVariant.ghost
          ? null
          : LiquidGlass.shadow(context),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: child,
    );
  }
}

class LiquidIconButton extends StatelessWidget {
  const LiquidIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = scheme.primary.withValues(alpha: isDark ? 0.2 : 0.14);

    final radius = LiquidGlass.borderRadius(AppRadii.md);
    final button = LiquidTapShell(
      onPressed: onPressed,
      borderRadius: radius,
      fillTop: LiquidGlass.panelFillTop(context, tint: accent),
      fillBottom: LiquidGlass.panelFillBottom(context, tint: accent),
      border: LiquidGlass.borderColor(context),
      shadows: LiquidGlass.shadowSubtle(context),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: scheme.primary, size: 22),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

class LiquidChoiceChip extends StatelessWidget {
  const LiquidChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    return LiquidTapShell(
      onPressed: () => onSelected(!selected),
      borderRadius: LiquidButtons._chipRadius,
      fillTop: selected
          ? LiquidGlass.insetFill(context, accent)
          : LiquidGlass.panelFillTop(context),
      fillBottom: selected
          ? LiquidGlass.insetFill(context, accent)
          : LiquidGlass.panelFillBottom(context),
      border: selected
          ? accent.withValues(alpha: 0.35)
          : LiquidGlass.borderColor(context),
      shadows: selected ? LiquidGlass.shadowSubtle(context) : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            Icon(Icons.check_rounded, size: 16, color: scheme.primary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected
                      ? scheme.primary
                      : LiquidGlass.textPrimary(context),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class LiquidActionChip extends StatelessWidget {
  const LiquidActionChip({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onPressed == null;

    return LiquidTapShell(
      onPressed: onPressed,
      borderRadius: LiquidButtons._chipRadius,
      fillTop: LiquidGlass.panelFillTop(context),
      fillBottom: LiquidGlass.panelFillBottom(context),
      border: LiquidGlass.borderColor(context),
      shadows: disabled ? null : LiquidGlass.shadowSubtle(context),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: disabled
                ? scheme.onSurface.withValues(alpha: 0.35)
                : scheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: disabled
                      ? scheme.onSurface.withValues(alpha: 0.35)
                      : scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// Frosted bar for wizard / sheet footers.
class LiquidBar extends StatelessWidget {
  const LiquidBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            LiquidGlass.panelFillTop(context),
            LiquidGlass.panelFillBottom(context),
          ],
        ),
        border: Border(
          top: BorderSide(color: LiquidGlass.borderColor(context), width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.08,
            ),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class LiquidTapShell extends StatelessWidget {
  const LiquidTapShell({
    super.key,
    required this.onPressed,
    required this.borderRadius,
    required this.fillTop,
    required this.fillBottom,
    required this.border,
    required this.padding,
    required this.child,
    this.shadows,
  });

  final VoidCallback? onPressed;
  final BorderRadius borderRadius;
  final Color fillTop;
  final Color fillBottom;
  final Color border;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final scheme = Theme.of(context).colorScheme;

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: fillTop == fillBottom
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [fillTop, fillBottom],
              ),
        color: fillTop == fillBottom ? fillTop : null,
        border: border.a > 0
            ? Border.all(color: border, width: 1.1)
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: disabled ? null : onPressed,
            borderRadius: borderRadius,
            splashColor: scheme.primary.withValues(alpha: 0.14),
            highlightColor: scheme.primary.withValues(alpha: 0.06),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );

  if (disabled || shadows == null || shadows!.isEmpty) {
      return surface;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: surface,
    );
  }
}
