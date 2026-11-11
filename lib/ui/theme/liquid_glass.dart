import 'package:flutter/material.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';

/// Liquid surfaces: opaque gradient panels (no [BackdropFilter]), soft canvas behind.
abstract final class LiquidGlass {
  static bool _isDark(Brightness b) => b == Brightness.dark;

  // —— Opaque panel gradient (liquid look without see-through text) ——
  static Color panelGradientTop(Brightness brightness, {Color? tint}) {
    final isDark = _isDark(brightness);
    var color = isDark ? const Color(0xFF2C3A50) : const Color(0xFFFFFFFF);
    if (tint != null) {
      color = Color.alphaBlend(tint.withValues(alpha: isDark ? 0.16 : 0.08), color);
    }
    return color;
  }

  static Color panelGradientBottom(Brightness brightness, {Color? tint}) {
    final isDark = _isDark(brightness);
    var color = isDark ? const Color(0xFF1A2332) : const Color(0xFFF1F5F9);
    if (tint != null) {
      color = Color.alphaBlend(tint.withValues(alpha: isDark ? 0.22 : 0.12), color);
    }
    return color;
  }

  static Color panelFill(BuildContext context, {Color? tint}) =>
      panelGradientTop(Theme.of(context).brightness, tint: tint);

  static Color panelFillTop(BuildContext context, {Color? tint}) =>
      panelGradientTop(Theme.of(context).brightness, tint: tint);

  static Color panelFillBottom(BuildContext context, {Color? tint}) =>
      panelGradientBottom(Theme.of(context).brightness, tint: tint);

  /// Button / chip surfaces (same opaque family as panels).
  static Color panelColor(Brightness brightness, {Color? tint}) =>
      panelGradientTop(brightness, tint: tint);

  static Color fieldFill(Brightness brightness) {
    final isDark = _isDark(brightness);
    return isDark ? const Color(0xFF243044) : const Color(0xFFFFFFFF);
  }

  static Color fieldFillOf(BuildContext context) =>
      fieldFill(Theme.of(context).brightness);

  static Color borderColor(BuildContext context) =>
      borderColorFor(Theme.of(context).brightness);

  static Color borderColorFor(Brightness brightness) {
    final isDark = _isDark(brightness);
    return isDark
        ? const Color(0xFF64748B).withValues(alpha: 0.55)
        : const Color(0xFF94A3B8).withValues(alpha: 0.55);
  }

  static Color highlightBorder(Brightness brightness) {
    final isDark = _isDark(brightness);
    return Colors.white.withValues(alpha: isDark ? 0.14 : 0.85);
  }

  static Color insetFill(BuildContext context, Color accent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    return Color.alphaBlend(
      accent.withValues(alpha: isDark ? 0.26 : 0.14),
      base,
    );
  }

  static Color insetBorder(Color accent, Brightness brightness) =>
      accent.withValues(alpha: _isDark(brightness) ? 0.5 : 0.38);

  static Color primaryActionFill(ColorScheme scheme, Brightness brightness) {
    final isDark = _isDark(brightness);
    return isDark ? scheme.primary : const Color(0xFF0D9488);
  }

  static Color primaryActionFillBottom(ColorScheme scheme, Brightness brightness) {
    final top = primaryActionFill(scheme, brightness);
    return Color.alphaBlend(Colors.black.withValues(alpha: 0.12), top);
  }

  // —— Text: full contrast on opaque panels; muted only when intentional ——
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color textSecondary(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? scheme.onSurface.withValues(alpha: 0.92)
        : const Color(0xFF334155);
  }

  static Color textTertiary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78)
        : const Color(0xFF64748B);
  }

  static Color textPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62)
        : const Color(0xFF94A3B8);
  }

  static TextStyle? bodySecondary(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textSecondary(context),
            height: 1.35,
          );

  static TextStyle? bodyTertiary(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textTertiary(context),
            height: 1.35,
          );

  static BorderRadius borderRadius([double? radius]) =>
      BorderRadius.circular(radius ?? AppRadii.liquid);

  static List<BoxShadow> shadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
        blurRadius: 22,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
    ];
  }

  /// Soft drop shadow for chips / icon buttons (avoids harsh edges).
  static List<BoxShadow> shadowSubtle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
        blurRadius: 10,
        offset: const Offset(0, 3),
        spreadRadius: -2,
      ),
    ];
  }

  static InputDecorationTheme inputDecorationTheme(
    Brightness brightness,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final isDark = _isDark(brightness);
    final border = borderColorFor(brightness);
    return InputDecorationTheme(
      filled: true,
      fillColor: fieldFill(brightness),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: isDark
            ? scheme.onSurface.withValues(alpha: 0.62)
            : const Color(0xFF94A3B8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: border, width: 1.25),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: border, width: 1.25),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
