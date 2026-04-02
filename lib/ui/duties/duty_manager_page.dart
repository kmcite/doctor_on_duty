import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/ui/ui.dart';
import 'package:flutter/material.dart';

class DutyManagerPage extends UI {
  const DutyManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duty Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDutyDialog(context),
            tooltip: 'Add Duty',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Total Duties',
                    state.duties.duties.length.toString(),
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'This Week',
                    state.duties.thisWeek.length.toString(),
                    Icons.date_range,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Today',
                    state.duties.today.length.toString(),
                    Icons.today,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Duty List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.duties.duties.length,
              itemBuilder: (context, index) {
                final duty = state.duties.duties.elementAt(index);
                return _buildDutyCard(context, duty);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyCard(BuildContext context, Duty duty) {
    final cases = duty.cases.toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getTimeColor(duty.startTime).withValues(alpha: 0.1),
          child: Icon(
            _getTimeIcon(duty.startTime),
            color: _getTimeColor(duty.startTime),
          ),
        ),
        title: Text(
          'Duty - ${duty.startTime != null ? _formatTime(duty.startTime!) : 'Time not set'}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${duty.date.day}-${duty.date.month}-${duty.date.year}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cases.isNotEmpty) ...[
              Chip(
                label: Text('${cases.length} cases'),
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditDutyDialog(context, duty);
                } else if (value == 'delete') {
                  _showDeleteDutyDialog(context, duty);
                }
              },
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (duty.notes.isNotEmpty) ...[
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(duty.notes),
                  const SizedBox(height: 12),
                ],
                if (cases.isNotEmpty) ...[
                  Text(
                    'Cases (${cases.length}):',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...cases.map(
                    (caze) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              caze.patientName.isNotEmpty
                                  ? caze.patientName
                                  : 'Unnamed Patient',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Text(
                            caze.type,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getCaseTypeColor(caze.type),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'No cases assigned to this duty',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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

  Color _getCaseTypeColor(String type) {
    switch (type) {
      case 'emergency':
        return Colors.red;
      case 'opd':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showAddDutyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _DutyDialog(
        title: 'Add Duty',
        onSave: (date, notes) {
          final duty = Duty(
            date: date,
            startTime: DateTime.now(),
          );
          apply(Put(duty));
        },
      ),
    );
  }

  void _showEditDutyDialog(BuildContext context, Duty duty) {
    showDialog(
      context: context,
      builder: (context) => _DutyDialog(
        title: 'Edit Duty',
        initialDate: duty.date,
        initialNotes: duty.notes,
        onSave: (date, notes) {
          duty.date = date;
          duty.notes = notes;
          apply(Put(duty));
        },
      ),
    );
  }

  void _showDeleteDutyDialog(BuildContext context, Duty duty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Duty'),
        content: Text(
          'Are you sure you want to delete the duty from ${duty.date.day}-${duty.date.month}-${duty.date.year}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              apply(Remove<Duty>(duty.id));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DutyDialog extends StatefulWidget {
  final String title;
  final DateTime? initialDate;
  final String? initialNotes;
  final Function(DateTime date, String notes) onSave;

  const _DutyDialog({
    required this.title,
    this.initialDate,
    this.initialNotes,
    required this.onSave,
  });

  @override
  State<_DutyDialog> createState() => _DutyDialogState();
}

class _DutyDialogState extends State<_DutyDialog> {
  late DateTime selectedDate;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    notesController = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(
                '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ),
            const Divider(),

            // Notes field
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(selectedDate, notesController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
