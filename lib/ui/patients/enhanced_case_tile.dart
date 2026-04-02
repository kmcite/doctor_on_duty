import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/ui.dart';

class EnhancedCaseTile extends UI {
  final Patient caze;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const EnhancedCaseTile({
    super.key,
    required this.caze,
    required this.isFavorite,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with patient info and favorite button
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      caze.patientName.isNotEmpty
                          ? caze.patientName
                          : 'Unnamed Patient',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (caze.age > 0) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.cake, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${caze.age}y',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (caze.gender.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.wc, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      caze.gender,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(width: 8),
                  // Favorite button
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Clinical Summary (show symptoms or provisional diagnosis)
              if (caze.symptoms.isNotEmpty)
                Text(
                  caze.symptoms,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else if (caze.provisionalDiagnosis.isNotEmpty)
                Text(
                  'Provisional: ${caze.provisionalDiagnosis}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: 10),

              // Status + Type + Category row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildChip(caze.status, Colors.blue),
                  _buildChip(caze.type, Colors.redAccent),
                  _buildChip(caze.category, Colors.green),
                ],
              ),
              const SizedBox(height: 10),

              // Management Info
              if (caze.treatmentPlan.isNotEmpty)
                Text(
                  'Treatment: ${caze.treatmentPlan}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue[600],
                  ),
                ),
              if (caze.progressNotes.isNotEmpty)
                Text(
                  'Progress: ${caze.progressNotes}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
