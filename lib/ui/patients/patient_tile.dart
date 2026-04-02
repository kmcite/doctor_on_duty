import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/ui.dart';

class PatientTile extends UI {
  final Patient patient;
  final VoidCallback? onTap;

  const PatientTile({
    super.key,
    required this.patient,
    this.onTap,
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
              // Patient Info
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    patient.patientName.isNotEmpty
                        ? patient.patientName
                        : 'Unnamed Patient',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (patient.age > 0) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.cake, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${patient.age}y',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (patient.gender.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.wc, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      patient.gender,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Clinical Summary (show symptoms or provisional diagnosis)
              if (patient.symptoms.isNotEmpty)
                Text(
                  patient.symptoms,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else if (patient.provisionalDiagnosis.isNotEmpty)
                Text(
                  'Provisional: ${patient.provisionalDiagnosis}',
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
                  _buildChip(patient.status, Colors.blue),
                  _buildChip(patient.type, Colors.redAccent),
                  _buildChip(patient.category, Colors.green),
                ],
              ),
              const SizedBox(height: 10),

              // Management Info
              if (patient.treatmentPlan.isNotEmpty)
                Text(
                  'Treatment: ${patient.treatmentPlan}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue[600],
                  ),
                ),
              if (patient.progressNotes.isNotEmpty)
                Text(
                  'Progress: ${patient.progressNotes}',
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
