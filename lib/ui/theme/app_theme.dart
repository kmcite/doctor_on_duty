import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_buttons.dart';
import 'package:flutter/material.dart';

/// Bundled in [pubspec.yaml] under `fonts:` → family `Lotion`.
const _appFontFamily = 'Lotion';

/// Layout tokens used across screens.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double pageHorizontal = 20;
}

abstract final class AppRadii {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double liquid = 26;
  static const double pill = 999;
}

/// Brand colors for clinical / duty workflow UI.
abstract final class AppColors {
  static const seed = Color(0xFF0D9488);
  static const seedDark = Color(0xFF2DD4BF);
  static const onDuty = Color(0xFF059669);
  static const offDuty = Color(0xFF64748B);
  static const emergency = Color(0xFFDC2626);
  static const opd = Color(0xFF2563EB);
}

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.seedDark : AppColors.seed;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      onPrimary: isDark ? const Color(0xFF042F2E) : Colors.white,
      secondary: const Color(0xFF0891B2),
      surface: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      onSurface: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0B1220),
      outlineVariant: isDark
          ? const Color(0xFF334155)
          : const Color(0xFFE2E8F0),
    );

    final base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: brightness,
    );

    final textTheme = base.textTheme.apply(
      fontFamily: _appFontFamily,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    final primaryTextTheme = base.primaryTextTheme.apply(
      fontFamily: _appFontFamily,
    );

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
      ),
      filledButtonTheme:
          FilledButtonThemeData(style: LiquidButtons.filled(brightness, colorScheme)),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: LiquidButtons.outlined(brightness, colorScheme)),
      textButtonTheme:
          TextButtonThemeData(style: LiquidButtons.text(brightness, colorScheme)),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: LiquidButtons.segmented(brightness, colorScheme),
      ),
      inputDecorationTheme: LiquidGlass.inputDecorationTheme(
        brightness,
        colorScheme,
        textTheme,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    );
  }
}
