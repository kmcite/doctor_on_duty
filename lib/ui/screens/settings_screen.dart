import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/dark.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:doctor_on_duty/ui/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    final isDark = theme.isDark;

    return LiquidScaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitleRow(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dark mode'),
                  subtitle: Text(
                    isDark ? 'On — easier on the eyes at night' : 'Off',
                    style: LiquidGlass.bodyTertiary(context),
                  ),
                  value: isDark,
                  onChanged: (_) => theme.toggle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitleRow(
                  icon: Icons.calendar_month_outlined,
                  title: 'Weekly roster',
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'M 8–2 · E 2–8 · N 8–8 — tap shifts for each day.',
                  style: LiquidGlass.bodySecondary(context),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () =>
                      openRoute(context, AppRoutes.weeklyDutySetup),
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Edit week schedule'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
