import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_buttons.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_panel.dart';
import 'package:doctor_on_duty/ui/widgets/quick_action_tile.dart';
import 'package:doctor_on_duty/business/duties.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'today_cases_section.dart';
import 'today_duty_section.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final duties = context.read<DutiesController>();
      if (!duties.hasWeeklySchedule) {
        Navigator.of(context).pushNamed(
          AppRoutes.weeklyDutySetup,
          arguments: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final dateLabel = DateFormat('EEEE, d MMMM').format(now);

    return LiquidScaffold(
      floatingActionButton: LiquidFab(
        onPressed: () => openRoute(context, AppRoutes.addPatient),
        icon: Icons.person_add_alt_1_rounded,
        label: 'New case',
      ),
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.md,
                AppSpacing.pageHorizontal,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: LiquidPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.lg,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor on Duty',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              dateLabel,
                              style: LiquidGlass.bodySecondary(context),
                            ),
                          ],
                        ),
                      ),
                      LiquidIconButton(
                        tooltip: 'Settings',
                        onPressed: () =>
                            openRoute(context, AppRoutes.settings),
                        icon: Icons.settings_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.md,
              AppSpacing.pageHorizontal,
              100,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Quick actions',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                QuickActionTile(
                  icon: Icons.assignment_outlined,
                  label: 'All cases',
                  subtitle: 'Browse and manage cases',
                  color: scheme.primary,
                  onTap: () => openRoute(context, AppRoutes.patients),
                ),
                const SizedBox(height: AppSpacing.sm),
                QuickActionTile(
                  icon: Icons.schedule_outlined,
                  label: 'Duty manager',
                  subtitle: 'Shifts, roster, and history',
                  color: const Color(0xFF7C3AED),
                  onTap: () => openRoute(context, AppRoutes.dutyManager),
                ),
                const SizedBox(height: AppSpacing.lg),
                const TodayDutySection(),
                const SizedBox(height: AppSpacing.md),
                const TodayCasesSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
