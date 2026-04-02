import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/case_deletion_dialog.dart';
import 'package:doctor_on_duty/ui/change_suggestor.dart';
import 'package:doctor_on_duty/ui/ui.dart';

class PatientDetailsScreen extends UI {
  final int patientId;
  Patient? get safePatient => state.patients.getById(patientId);
  Patient get unsafePatient => state.patients.getById(patientId)!;
  const PatientDetailsScreen({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    if (safePatient == null) {
      apply(NavigateBack());
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Go back',
          ),
        ),
        body: Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: patientId.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' is already deleted or not available',
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          unsafePatient.patientName.isNotEmpty
              ? unsafePatient.patientName
              : 'Unnamed Patient',
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              apply(
                ShowDialog(
                  (_, _, _) => CaseDeletionDialog(caseId: patientId),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              apply(
                ShowDialog(
                  (_, _, _) => MedicalCaseModifier(caseId: patientId),
                ),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Information Card
            _buildPatientInfoCard(context),
            const SizedBox(height: 24),

            // Clinical Presentation Card
            _buildClinicalPresentationCard(context),
            const SizedBox(height: 24),

            // Diagnosis Card
            _buildDiagnosisCard(context),
            const SizedBox(height: 24),

            // Management Card
            _buildManagementCard(context),
            const SizedBox(height: 24),

            // Duty Information (if available)
            if (unsafePatient.duty.target != null) _buildDutyCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Patient Information',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Name',
                    unsafePatient.patientName,
                    Icons.person,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    'Age',
                    '${unsafePatient.age}',
                    Icons.cake,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    'Gender',
                    unsafePatient.gender,
                    Icons.wc,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildClinicalPresentationCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medical_information,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Clinical Presentation',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (unsafePatient.symptoms.isNotEmpty)
              _buildDetailSection(
                context,
                'Symptoms',
                unsafePatient.symptoms,
                Icons.sick,
              ),
            if (unsafePatient.signs.isNotEmpty)
              _buildDetailSection(
                context,
                'Signs',
                unsafePatient.signs,
                Icons.visibility,
              ),
            if (unsafePatient.vitals.isNotEmpty)
              _buildDetailSection(
                context,
                'Vitals',
                unsafePatient.vitals,
                Icons.monitor_heart,
              ),
            if (unsafePatient.history.isNotEmpty)
              _buildDetailSection(
                context,
                'History',
                unsafePatient.history,
                Icons.history,
              ),
            if (unsafePatient.examination.isNotEmpty)
              _buildDetailSection(
                context,
                'Examination',
                unsafePatient.examination,
                Icons.search,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Diagnosis',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (unsafePatient.provisionalDiagnosis.isNotEmpty)
              _buildDetailSection(
                context,
                'Provisional',
                unsafePatient.provisionalDiagnosis,
                Icons.help_outline,
              ),
            if (unsafePatient.finalDiagnosis.isNotEmpty)
              _buildDetailSection(
                context,
                'Final',
                unsafePatient.finalDiagnosis,
                Icons.check_circle,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.healing,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Management',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusCards(context),
            const SizedBox(height: 16),
            if (unsafePatient.treatmentPlan.isNotEmpty)
              _buildDetailSection(
                context,
                'Treatment Plan',
                unsafePatient.treatmentPlan,
                Icons.medication,
              ),
            if (unsafePatient.progressNotes.isNotEmpty)
              _buildDetailSection(
                context,
                'Progress Notes',
                unsafePatient.progressNotes,
                Icons.note,
              ),
            if (unsafePatient.outcome.isNotEmpty)
              _buildDetailSection(
                context,
                'Outcome',
                unsafePatient.outcome,
                Icons.flag,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.work,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Duty Information',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${unsafePatient.duty.target?.date.toString().split(' ')[0] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Started: ${unsafePatient.duty.target?.startTime != null ? _formatTime(unsafePatient.duty.target!.startTime!) : 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (unsafePatient.duty.target?.notes.isNotEmpty == true)
              Text(
                'Notes: ${unsafePatient.duty.target!.notes}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            context,
            "Status",
            unsafePatient.status,
            Icons.info,
            _getStatusColor(context, unsafePatient.status),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            context,
            "Type",
            unsafePatient.type,
            Icons.category,
            _getTypeColor(context, unsafePatient.type),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            context,
            "Category",
            unsafePatient.category,
            Icons.label,
            _getCategoryColor(context, unsafePatient.category),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'ongoing':
        return Colors.orange;
      case 'discharged':
        return Colors.green;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'emergency':
        return Colors.red;
      case 'opd':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor(BuildContext context, String category) {
    switch (category.toLowerCase()) {
      case 'general':
        return Colors.green;
      case 'special':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
