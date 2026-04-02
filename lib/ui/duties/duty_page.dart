import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/ui/ui.dart';
import 'package:flutter/material.dart';

class DutyPage extends UI {
  const DutyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duty Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                apply(ShowDialog((_, _, _) => const AddDutyDialog())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Duty Card
            _buildCurrentDutyCard(context),
            const SizedBox(height: 24),

            // Today's Duties
            _buildSectionHeader(context, 'Today\'s Duties', Icons.today),
            const SizedBox(height: 12),
            _buildDutiesList(state.duties.today.toList()),
            const SizedBox(height: 24),

            // This Week's Duties
            _buildSectionHeader(
              context,
              'This Week\'s Duties',
              Icons.date_range,
            ),
            const SizedBox(height: 12),
            _buildDutiesList(state.duties.thisWeek.toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentDutyCard(BuildContext context) {
    final currentDuty = state.duties.currentDuty;

    return Card(
      elevation: 4,
      color: currentDuty != null
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  currentDuty != null ? Icons.work : Icons.work_off,
                  size: 32,
                  color: currentDuty != null
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentDuty != null
                        ? 'Currently on Duty'
                        : 'No Current Duty',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: currentDuty != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if (currentDuty != null) ...[
              const SizedBox(height: 16),
              Text(
                'Started: ${currentDuty.startTime != null ? _formatTime(currentDuty.startTime!) : 'Not set'}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (currentDuty.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Notes: ${currentDuty.notes}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Cases on this duty: ${currentDuty.cases.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDutiesList(List<Duty> dutyList) {
    if (dutyList.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No duties scheduled',
            // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //   color: Colors.grey[600],
            // ),
          ),
        ),
      );
    }

    return Column(
      children: dutyList.map((duty) => _buildDutyTile(duty)).toList(),
    );
  }

  Widget _buildDutyTile(Duty duty) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTimeColor(duty.startTime).withValues(alpha: 0.1),
          child: Icon(
            _getTimeIcon(duty.startTime),
            color: _getTimeColor(duty.startTime),
          ),
        ),
        title: Text(
          duty.date.toString().split(' ')[0],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Started: ${duty.startTime != null ? _formatTime(duty.startTime!) : 'Not set'}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '${duty.cases.length} cases',
          style: TextStyle(
            // color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () =>
            apply(ShowDialog((_, _, _) => DutyDetailsDialog(duty: duty))),
      ),
    );
  }

  Color _getTimeColor(DateTime? startTime) {
    if (startTime == null) return Colors.grey;

    final hour = startTime.hour;
    if (hour >= 6 && hour < 12) {
      return Colors.orange; // Morning
    } else if (hour >= 12 && hour < 18) {
      return Colors.blue; // Afternoon
    } else if (hour >= 18 && hour < 22) {
      return Colors.purple; // Evening
    } else {
      return Colors.indigo; // Night
    }
  }

  IconData _getTimeIcon(DateTime? startTime) {
    if (startTime == null) return Icons.schedule;

    final hour = startTime.hour;
    if (hour >= 6 && hour < 12) {
      return Icons.wb_sunny; // Morning
    } else if (hour >= 12 && hour < 18) {
      return Icons.wb_cloudy; // Afternoon
    } else if (hour >= 18 && hour < 22) {
      return Icons.wb_twilight; // Evening
    } else {
      return Icons.nightlight; // Night
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class AddDutyDialog extends StatefulWidget {
  const AddDutyDialog({super.key});

  @override
  State<AddDutyDialog> createState() => _AddDutyDialogState();
}

class _AddDutyDialogState extends State<AddDutyDialog> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Add New Duty',
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

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Date Picker
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle: Text(_selectedDate.toString().split(' ')[0]),
                    onTap: _selectDate,
                  ),

                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      prefixIcon: Icon(Icons.note),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => apply(NavigateBack()),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveDuty,
                  child: const Text('Add Duty'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _saveDuty() async {
    if (!_formKey.currentState!.validate()) return;

    final duty = Duty(
      date: _selectedDate,
      startTime:
          DateTime.now(), // Set start time to current time when adding duty
    );
    duty.notes = _notesController.text.trim();

    try {
      apply(Put(duty));
      if (mounted) {
        apply(NavigateBack());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Duty added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding duty: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class DutyDetailsDialog extends StatelessWidget {
  final Duty duty;

  const DutyDetailsDialog({super.key, required this.duty});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Duty Details',
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

            _buildDetailRow(
              'Date',
              duty.date.toString().split(' ')[0],
              Icons.calendar_today,
            ),
            _buildDetailRow(
              'Started',
              duty.startTime != null ? _formatTime(duty.startTime!) : 'Not set',
              Icons.schedule,
            ),
            if (duty.notes.isNotEmpty)
              _buildDetailRow('Notes', duty.notes, Icons.note),
            _buildDetailRow('Cases', '${duty.cases.length}', Icons.people),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => apply(NavigateBack()),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
