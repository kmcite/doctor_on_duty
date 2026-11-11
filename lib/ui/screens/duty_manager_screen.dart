import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/duties.dart';
import 'package:doctor_on_duty/domain/duty_schedule.dart';
import 'package:doctor_on_duty/domain/models/duty.dart';
import 'package:doctor_on_duty/domain/models/duty_slot.dart';
import 'package:doctor_on_duty/domain/shift_kind.dart';
import 'package:doctor_on_duty/ui/shift_ui.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_buttons.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_panel.dart';
import 'package:doctor_on_duty/ui/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DutyManagerScreen extends StatelessWidget {
  const DutyManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: LiquidScaffold(
        appBar: AppBar(
          title: const Text('Duty manager'),
          bottom: TabBar(
            labelColor: scheme.primary,
            unselectedLabelColor: LiquidGlass.textTertiary(context),
            indicatorColor: scheme.primary,
            tabs: const [
              Tab(text: 'Weekly roster', icon: Icon(Icons.repeat)),
              Tab(text: 'Duty log', icon: Icon(Icons.history)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: LiquidIconButton(
                tooltip: 'Edit week (M / E / N)',
                icon: Icons.edit_calendar,
                onPressed: () => openRoute(context, AppRoutes.weeklyDutySetup),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _WeeklyScheduleTab(),
            _DutyLogTab(),
          ],
        ),
      ),
    );
  }
}

class _WeeklyScheduleTab extends StatelessWidget {
  const _WeeklyScheduleTab();

  int _shiftOrder(DutySlot slot) => switch (ShiftKind.resolve(slot)) {
        ShiftKind.morning => 0,
        ShiftKind.evening => 1,
        ShiftKind.night => 2,
        _ => 3,
      };

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DutiesController>();
    final slots = List<DutySlot>.from(ctrl.weeklySlots);
    final today = DateTime.now().weekday;

    final byDay = <int, List<DutySlot>>{};
    for (var w = DateTime.monday; w <= DateTime.sunday; w++) {
      final daySlots = slots.where((s) => s.weekday == w).toList()
        ..sort((a, b) => _shiftOrder(a).compareTo(_shiftOrder(b)));
      byDay[w] = daySlots;
    }

    final hasAny = slots.isNotEmpty;
    final bottom = MediaQuery.paddingOf(context).bottom;

    if (!hasAny) {
      return ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.xl,
          AppSpacing.pageHorizontal,
          AppSpacing.pageHorizontal + bottom,
        ),
        children: [
          _EmptyPanel(
            icon: Icons.calendar_month_outlined,
            title: 'No week roster yet',
            body: 'Set M, E, and N shifts for each day. The hub shift panel uses this schedule.',
            action: LiquidButton(
              icon: Icons.edit_calendar,
              label: 'Set up week',
              onPressed: () => openRoute(context, AppRoutes.weeklyDutySetup),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.pageHorizontal + bottom,
      ),
      children: [
        _RosterSummaryCard(ctrl: ctrl),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: LiquidButton(
            variant: LiquidButtonVariant.secondary,
            icon: Icons.edit_outlined,
            label: 'Edit week',
            onPressed: () => openRoute(context, AppRoutes.weeklyDutySetup),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...List.generate(7, (i) {
          final weekday = i + 1;
          final daySlots = byDay[weekday]!;
          final isToday = weekday == today;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: LiquidPanel(
              tint: isToday
                  ? Theme.of(context).colorScheme.primary
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DutySchedule.weekdayLabel(weekday, full: true),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      if (isToday) const _TodayPill(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (daySlots.isEmpty)
                    Text(
                      'Off — no shifts',
                      style: LiquidGlass.bodyTertiary(context),
                    )
                  else
                    ...daySlots.map((slot) => _ShiftRow(slot: slot)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _RosterSummaryCard extends StatelessWidget {
  const _RosterSummaryCard({required this.ctrl});

  final DutiesController ctrl;

  @override
  Widget build(BuildContext context) {
    final onDuty = ctrl.isOnDuty;
    final accent = onDuty ? AppColors.onDuty : AppColors.offDuty;
    final next = ctrl.nextDutyStart;
    final until = ctrl.timeUntilNextDuty;
    final count = ctrl.weeklySlots.length;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleRow(
            icon: Icons.badge_outlined,
            title: 'This week',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                onDuty ? 'On duty' : 'Off duty',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$count shift${count == 1 ? '' : 's'} on your roster',
            style: LiquidGlass.bodySecondary(context),
          ),
          if (!onDuty && next != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Next: ${DateFormat('EEE d MMM · HH:mm').format(next)}'
              '${until != null ? ' (${DutySchedule.formatDuration(until)})' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _TodayPill extends StatelessWidget {
  const _TodayPill();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        'Today',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ShiftRow extends StatelessWidget {
  const _ShiftRow({required this.slot});

  final DutySlot slot;

  Future<void> _confirmRemove(BuildContext context) async {
    final kind = ShiftKind.resolve(slot);
    final day = DutySchedule.weekdayLabel(slot.weekday, full: true);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove shift?'),
        content: Text(
          'Remove ${ShiftKind.label(kind)} on $day from your repeating roster?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<DutiesController>().removeSlot(slot.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kind = ShiftKind.resolve(slot);
    final color = ShiftUi.accent(context, kind);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          LiquidInset(
            accent: color,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              ShiftKind.shortLabel(kind),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ShiftKind.label(kind),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  ShiftKind.timeRangeLabel(kind),
                  style: LiquidGlass.bodyTertiary(context),
                ),
              ],
            ),
          ),
          LiquidIconButton(
            tooltip: 'Remove shift',
            icon: Icons.close_rounded,
            onPressed: () => _confirmRemove(context),
          ),
        ],
      ),
    );
  }
}

class _DutyLogTab extends StatelessWidget {
  const _DutyLogTab();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DutiesController>();
    final sorted = List<Duty>.from(ctrl.duties)
      ..sort((a, b) {
        final aStart = a.startTime ?? a.date;
        final bStart = b.startTime ?? b.date;
        return bStart.compareTo(aStart);
      });

    final bottom = MediaQuery.paddingOf(context).bottom;

    if (sorted.isEmpty) {
      return ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.xl,
          AppSpacing.pageHorizontal,
          AppSpacing.pageHorizontal + bottom,
        ),
        children: const [
          _EmptyPanel(
            icon: Icons.history,
            title: 'No duty sessions yet',
            body:
                'A session starts when you log a case on duty or end a shift from the hub.',
          ),
        ],
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.pageHorizontal + bottom,
      ),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final duty = sorted[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _DutyLogCard(duty: duty, cases: ctrl.patientCountForDuty(duty.id)),
        );
      },
    );
  }
}

class _DutyLogCard extends StatelessWidget {
  const _DutyLogCard({required this.duty, required this.cases});

  final Duty duty;
  final int cases;

  @override
  Widget build(BuildContext context) {
    final start = duty.startTime;
    final end = duty.endTime;
    final active = !duty.isEnded;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('EEE, d MMM y').format(duty.date),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (active)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.onDuty.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(
                    'Active',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onDuty,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _sessionTimeLabel(start, end, cases),
            style: LiquidGlass.bodySecondary(context),
          ),
          if (duty.notes.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              duty.notes.trim(),
              style: LiquidGlass.bodyTertiary(context),
            ),
          ],
        ],
      ),
    );
  }

  String _sessionTimeLabel(DateTime? start, DateTime? end, int cases) {
    final startStr = start != null ? DateFormat.Hm().format(start) : '—';
    final endStr = end != null ? DateFormat.Hm().format(end) : 'ongoing';
    return '$startStr → $endStr · $cases case${cases == 1 ? '' : 's'}';
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          Icon(icon, size: 48, color: LiquidGlass.textTertiary(context)),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: LiquidGlass.bodySecondary(context),
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
