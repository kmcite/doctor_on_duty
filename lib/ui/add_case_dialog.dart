import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../main.dart';

class AddPatientDialog extends StatefulWidget {
  const AddPatientDialog({super.key});

  @override
  State<AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form state using RM.inject
  final patientNameRM = RM.inject(() => '');
  final ageRM = RM.inject(() => '');
  final genderRM = RM.inject(() => '');
  final symptomsRM = RM.inject(() => '');
  final signsRM = RM.inject(() => '');
  final vitalsRM = RM.inject(() => '');
  final historyRM = RM.inject(() => '');
  final examinationRM = RM.inject(() => '');
  final provisionalDiagnosisRM = RM.inject(() => '');
  final finalDiagnosisRM = RM.inject(() => '');
  final treatmentPlanRM = RM.inject(() => '');
  final progressNotesRM = RM.inject(() => '');
  final outcomeRM = RM.inject(() => '');
  final statusRM = RM.inject(() => 'open');
  final typeRM = RM.inject(() => 'emergency');
  final categoryRM = RM.inject(() => 'general');

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add New Case',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => apply(NavigateBack()),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Patient Information Section
                        _buildSectionHeader('Patient Information'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: patientNameRM,
                          label: 'Patient Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter patient name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: ageRM,
                          label: 'Age',
                          icon: Icons.cake,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter age';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: genderRM,
                          label: 'Gender',
                          icon: Icons.wc,
                        ),
                        const SizedBox(height: 16),

                        // Clinical Presentation Section
                        _buildSectionHeader('Clinical Presentation'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: symptomsRM,
                          label: 'Symptoms',
                          icon: Icons.sick,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: signsRM,
                          label: 'Signs',
                          icon: Icons.visibility,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: vitalsRM,
                          label: 'Vitals',
                          icon: Icons.monitor_heart,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: historyRM,
                          label: 'History',
                          icon: Icons.history,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: examinationRM,
                          label: 'Examination',
                          icon: Icons.search,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // Diagnosis Section
                        _buildSectionHeader('Diagnosis'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: provisionalDiagnosisRM,
                          label: 'Provisional Diagnosis',
                          icon: Icons.help_outline,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: finalDiagnosisRM,
                          label: 'Final Diagnosis',
                          icon: Icons.check_circle,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        // Management Section
                        _buildSectionHeader('Management'),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Status',
                          value: statusRM.state,
                          icon: Icons.info,
                          items: ['open', 'ongoing', 'discharged', 'critical'],
                          onChanged: (value) => statusRM.state = value!,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Type',
                          value: typeRM.state,
                          icon: Icons.category,
                          items: ['emergency', 'opd'],
                          onChanged: (value) => typeRM.state = value!,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Category',
                          value: categoryRM.state,
                          icon: Icons.label,
                          items: ['general', 'special'],
                          onChanged: (value) => categoryRM.state = value!,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: treatmentPlanRM,
                          label: 'Treatment Plan',
                          icon: Icons.medication,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: progressNotesRM,
                          label: 'Progress Notes',
                          icon: Icons.note,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          rm: outcomeRM,
                          label: 'Outcome',
                          icon: Icons.flag,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => apply(NavigateBack()),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveCase,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: YaruCircularProgressIndicator(),
                          )
                        : const Text('Add Case'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required Injected<String> rm,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: rm.state,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      maxLines: maxLines,
      validator: validator,
      onChanged: (value) => rm.state = value,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _saveCase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create new case object with form data
      final newCase = Patient();
      newCase.patientName = patientNameRM.state.trim();
      newCase.age = int.tryParse(ageRM.state.trim()) ?? 0;
      newCase.gender = genderRM.state.trim();
      newCase.symptoms = symptomsRM.state.trim();
      newCase.signs = signsRM.state.trim();
      newCase.vitals = vitalsRM.state.trim();
      newCase.history = historyRM.state.trim();
      newCase.examination = examinationRM.state.trim();
      newCase.provisionalDiagnosis = provisionalDiagnosisRM.state.trim();
      newCase.finalDiagnosis = finalDiagnosisRM.state.trim();
      newCase.status = statusRM.state;
      newCase.type = typeRM.state;
      newCase.category = categoryRM.state;
      newCase.treatmentPlan = treatmentPlanRM.state.trim();
      newCase.progressNotes = progressNotesRM.state.trim();
      newCase.outcome = outcomeRM.state.trim();

      apply(Put(newCase));

      if (mounted) {
        apply(NavigateBack());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding patient: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
