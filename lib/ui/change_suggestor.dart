import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class MedicalCaseModifier extends StatefulWidget {
  final int caseId;
  const MedicalCaseModifier({super.key, required this.caseId});

  @override
  State<MedicalCaseModifier> createState() => _MedicalCaseModifierState();
}

class _MedicalCaseModifierState extends State<MedicalCaseModifier> {
  Patient get caze => store.state.patients.getById(widget.caseId)!;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _patientNameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _symptomsController;
  late TextEditingController _signsController;
  late TextEditingController _vitalsController;
  late TextEditingController _historyController;
  late TextEditingController _examinationController;
  late TextEditingController _provisionalDiagnosisController;
  late TextEditingController _finalDiagnosisController;
  late TextEditingController _treatmentPlanController;
  late TextEditingController _progressNotesController;
  late TextEditingController _outcomeController;
  late String _selectedStatus;
  late String _selectedType;
  late String _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _patientNameController = TextEditingController(text: caze.patientName);
    _ageController = TextEditingController(text: caze.age.toString());
    _genderController = TextEditingController(text: caze.gender);
    _symptomsController = TextEditingController(text: caze.symptoms);
    _signsController = TextEditingController(text: caze.signs);
    _vitalsController = TextEditingController(text: caze.vitals);
    _historyController = TextEditingController(text: caze.history);
    _examinationController = TextEditingController(text: caze.examination);
    _provisionalDiagnosisController = TextEditingController(
      text: caze.provisionalDiagnosis,
    );
    _finalDiagnosisController = TextEditingController(
      text: caze.finalDiagnosis,
    );
    _treatmentPlanController = TextEditingController(text: caze.treatmentPlan);
    _progressNotesController = TextEditingController(text: caze.progressNotes);
    _outcomeController = TextEditingController(text: caze.outcome);
    _selectedStatus = caze.status;
    _selectedType = caze.type;
    _selectedCategory = caze.category;
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _symptomsController.dispose();
    _signsController.dispose();
    _vitalsController.dispose();
    _historyController.dispose();
    _examinationController.dispose();
    _provisionalDiagnosisController.dispose();
    _finalDiagnosisController.dispose();
    _treatmentPlanController.dispose();
    _progressNotesController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

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
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Update Case',
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
                        Text(
                          'Patient Information',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _patientNameController,
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
                          controller: _ageController,
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
                          controller: _genderController,
                          label: 'Gender',
                          icon: Icons.wc,
                        ),
                        const SizedBox(height: 16),

                        // Clinical Presentation Section
                        Text(
                          'Clinical Presentation',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _symptomsController,
                          label: 'Symptoms',
                          icon: Icons.sick,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _signsController,
                          label: 'Signs',
                          icon: Icons.visibility,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _vitalsController,
                          label: 'Vitals',
                          icon: Icons.monitor_heart,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _historyController,
                          label: 'History',
                          icon: Icons.history,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _examinationController,
                          label: 'Examination',
                          icon: Icons.search,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // Diagnosis Section
                        Text(
                          'Diagnosis',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _provisionalDiagnosisController,
                          label: 'Provisional Diagnosis',
                          icon: Icons.help_outline,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _finalDiagnosisController,
                          label: 'Final Diagnosis',
                          icon: Icons.check_circle,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        // Management Section
                        Text(
                          'Management',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Status',
                          value: _selectedStatus,
                          icon: Icons.info,
                          items: [
                            'open',
                            'ongoing',
                            'discharged',
                            'critical',
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Type',
                          value: _selectedType,
                          icon: Icons.category,
                          items: ['emergency', 'opd'],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Category',
                          value: _selectedCategory,
                          icon: Icons.label,
                          items: ['general', 'special'],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _treatmentPlanController,
                          label: 'Treatment Plan',
                          icon: Icons.medication,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _progressNotesController,
                          label: 'Progress Notes',
                          icon: Icons.note,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _outcomeController,
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
                    onPressed: _isLoading ? null : _saveChanges,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: YaruCircularProgressIndicator(),
                          )
                        : const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    // Ensure the current value is in the items list
    List<String> finalItems = List.from(items);
    if (value.isNotEmpty && !finalItems.contains(value)) {
      finalItems.insert(
        0,
        value,
      ); // Add current value at the beginning if not in list
    }

    // Use the first item as fallback if current value is empty or not found
    String dropdownValue = (value.isNotEmpty && finalItems.contains(value))
        ? value
        : finalItems.first;

    return DropdownButtonFormField<String>(
      initialValue: dropdownValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      items: finalItems.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update the case object with new model fields
      caze.patientName = _patientNameController.text.trim();
      caze.age = int.tryParse(_ageController.text.trim()) ?? 0;
      caze.gender = _genderController.text.trim();
      caze.symptoms = _symptomsController.text.trim();
      caze.signs = _signsController.text.trim();
      caze.vitals = _vitalsController.text.trim();
      caze.history = _historyController.text.trim();
      caze.examination = _examinationController.text.trim();
      caze.provisionalDiagnosis = _provisionalDiagnosisController.text.trim();
      caze.finalDiagnosis = _finalDiagnosisController.text.trim();
      caze.status = _selectedStatus;
      caze.type = _selectedType;
      caze.category = _selectedCategory;
      caze.treatmentPlan = _treatmentPlanController.text.trim();
      caze.progressNotes = _progressNotesController.text.trim();
      caze.outcome = _outcomeController.text.trim();

      apply(Put(caze));

      if (mounted) {
        apply(NavigateBack());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Case updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating case: $e'),
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
