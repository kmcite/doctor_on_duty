import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/patients.dart';
import 'package:doctor_on_duty/domain/models/case_catalog.dart';
import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/widgets/empty_state.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_panel.dart';
import 'package:doctor_on_duty/ui/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayCasesSection extends StatelessWidget {
  const TodayCasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = context.watch<PatientsController>();
    final today = patients.today.toList();
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleRow(
            icon: Icons.medical_information_outlined,
            title: 'Today\'s cases',
            trailing: today.isEmpty ? null : _CountPill(count: today.length),
          ),
          const SizedBox(height: AppSpacing.md),
          if (today.isEmpty)
            const EmptyState(
              icon: Icons.inbox_outlined,
              message: 'No cases logged today. Add one from the hub.',
            )
          else ...[
            _CaseTypeCard(
              title: 'All today',
              count: today.length,
              icon: Icons.list_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
              onTap: () => openRoute(context, AppRoutes.patients),
            ),
            for (final id in CaseType.all) ...[
              if (_countWithType(today, id) > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                _CaseTypeCard(
                  title: CaseType.label(id),
                  count: _countWithType(today, id),
                  icon: _iconForType(id),
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () => openRoute(context, AppRoutes.patients),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

int _countWithType(List<Patient> cases, String typeId) =>
    cases.where((p) => p.categories.contains(typeId)).length;

IconData _iconForType(String typeId) => switch (typeId) {
      CaseType.medical => Icons.local_hospital_outlined,
      CaseType.peds => Icons.child_care_outlined,
      CaseType.surgical => Icons.content_cut_outlined,
      CaseType.mlcAutopsy => Icons.gavel_outlined,
      CaseType.antiRabies => Icons.vaccines_outlined,
      _ => Icons.label_outline,
    };

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _CaseTypeCard extends StatelessWidget {
  const _CaseTypeCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LiquidPanel(
      onTap: onTap,
      tint: color,
      padding: const EdgeInsets.all(AppSpacing.md),
      radius: AppRadii.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$count',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
          ),
        ],
      ),
    );
  }
}
