import 'package:doctor_on_duty/domain/models/case_catalog.dart';
import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnhancedCaseTile extends StatelessWidget {
  const EnhancedCaseTile({
    super.key,
    required this.caze,
    required this.isFavorite,
    this.onTap,
    this.onFavoriteToggle,
  });

  final Patient caze;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final muted = LiquidGlass.textSecondary(context);
    return LiquidPanel(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: AppSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  caze.displayName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (caze.age > 0)
                Text('${caze.age}y', style: Theme.of(context).textTheme.bodySmall),
              if (caze.gender.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(caze.gender, style: Theme.of(context).textTheme.bodySmall),
              ],
              IconButton(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.emergency : muted,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('d MMM y, HH:mm').format(caze.arrivedAt),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 8),
          if (caze.presentationLine.isNotEmpty)
            Text(
              caze.presentationLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (caze.examination.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'O/E: ${caze.examination}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildChip(
                caze.caseCompletionLabel,
                caze.isCaseComplete ? AppColors.onDuty : AppColors.offDuty,
              ),
              for (final typeLabel in CaseType.labelsFor(caze.categories))
                _buildChip(typeLabel, Theme.of(context).colorScheme.secondary),
            ],
          ),
          if (caze.managementDocument.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              caze.managementDocument,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      visualDensity: VisualDensity.compact,
    );
  }
}
