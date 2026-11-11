import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/duties.dart';
import 'package:doctor_on_duty/domain/duty_schedule.dart';
import 'package:doctor_on_duty/domain/models/duty_slot.dart';
import 'package:doctor_on_duty/domain/shift_kind.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_panel.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_buttons.dart';
import 'package:doctor_on_duty/ui/widgets/section_card.dart';
import 'dart:async';

import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayDutySection extends StatelessWidget {
  const TodayDutySection({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final duties = context.watch<DutiesController>();

    if (!duties.hasWeeklySchedule) {
      return SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionTitleRow(
              icon: Icons.badge_outlined,
              title: 'Duty schedule',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Set your weekly duty times to see when you are on shift.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () =>
                  openRoute(context, AppRoutes.weeklyDutySetup),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Set weekly duties'),
            ),
          ],
        ),
      );
    }

    final onDuty = duties.isOnDuty;
    final slot = duties.activeSlot;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleRow(
            icon: Icons.badge_outlined,
            title: 'Shift — ${now.day}/${now.month}/${now.year}',
            trailing: _ShiftBadge(onDuty: onDuty),
          ),
          const SizedBox(height: AppSpacing.md),
          LiquidInset(
            accent: onDuty ? AppColors.onDuty : AppColors.offDuty,
            child: onDuty
                ? _OnDutyUi(duties: duties, slot: slot!)
                : _OffDutyUi(duties: duties),
          ),
        ],
      ),
    );
  }
}

class _ShiftBadge extends StatelessWidget {
  const _ShiftBadge({required this.onDuty});

  final bool onDuty;

  @override
  Widget build(BuildContext context) {
    final color = onDuty ? AppColors.onDuty : AppColors.offDuty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        onDuty ? 'On duty' : 'Off duty',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _OnDutyUi extends StatelessWidget {
  const _OnDutyUi({required this.duties, required this.slot});

  final DutiesController duties;
  final DutySlot slot;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = duties.remainingInDuty;
    final anchor = DutySchedule.anchorDayForSlot(slot, now);
    final start = DutySchedule.startOnDate(slot, anchor);
    final end = DutySchedule.endOnDate(slot, anchor);
    final kind = ShiftKind.resolve(slot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DutySchedule.slotTitle(slot),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          ShiftKind.label(kind),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        _InfoRow(
          icon: Icons.schedule,
          label: 'Time remaining',
          value: remaining != null
              ? DutySchedule.formatDuration(remaining)
              : '—',
        ),
        _InfoRow(
          icon: Icons.people_outline,
          label: 'Patients this duty',
          value: '${duties.patientsThisDuty}',
        ),
        _InfoRow(
          icon: Icons.login,
          label: 'Window',
          value:
              '${DateFormat.Hm().format(start)} – ${DateFormat.Hm().format(end)}',
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.center,
          child: LiquidButton(
            variant: LiquidButtonVariant.danger,
            icon: Icons.stop_circle_outlined,
            label: 'End duty early',
            onPressed: () {
              final notesCtrl = TextEditingController();
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('End duty early?'),
                  content: TextField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                    ),
                    maxLines: 2,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        duties.ensureTodaySession();
                        duties.endTodaySession(notes: notesCtrl.text);
                        Navigator.pop(ctx);
                      },
                      child: const Text('End duty'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OffDutyUi extends StatelessWidget {
  const _OffDutyUi({required this.duties});

  final DutiesController duties;

  @override
  Widget build(BuildContext context) {
    final next = duties.nextDutyStart;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You are off duty right now.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.offDuty,
              ),
        ),
        if (next != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.event,
            label: 'Next duty',
            value: DateFormat('EEE, d MMM · HH:mm').format(next),
          ),
        ] else
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Text('No upcoming shift in the next week.'),
          ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => openRoute(context, AppRoutes.dutyManager),
          icon: const Icon(Icons.edit_calendar),
          label: const Text('Edit schedule'),
        ),
        if (next != null) ...[
          const SizedBox(height: AppSpacing.md),
          const _NextDutyProgressBar(),
        ],
      ],
    );
  }
}

/// Off-duty countdown; ticks every minute at the bottom of the shift panel.
class _NextDutyProgressBar extends StatefulWidget {
  const _NextDutyProgressBar();

  @override
  State<_NextDutyProgressBar> createState() => _NextDutyProgressBarState();
}

class _NextDutyProgressBarState extends State<_NextDutyProgressBar> {
  Timer? _minuteTimer;

  @override
  void initState() {
    super.initState();
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duties = context.watch<DutiesController>();
    final remaining = duties.timeUntilNextDuty;
    final fraction = duties.offDutyRemainingFraction;
    if (remaining == null || fraction == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Until next duty',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              DutySchedule.formatDuration(remaining),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.opd,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: LiquidGlass.borderRadius(AppRadii.sm),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 10,
            backgroundColor: LiquidGlass.insetFill(context, AppColors.offDuty),
            color: AppColors.opd,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onDuty),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
