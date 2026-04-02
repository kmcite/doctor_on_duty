import 'package:doctor_on_duty/domain/api/duties.dart';
import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/ui/ui.dart';

import '../../main.dart';

class TodayDutySection extends UI {
  const TodayDutySection({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: .all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date
            Row(
              children: [
                Icon(Icons.calendar_today, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Today - ${now.day}/${now.month}/${now.year}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Duty Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: state.duties.isOnDuty
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.duties.isOnDuty
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: state.duties.isOnDuty ? _OnDutyUi() : _OffDuty(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnDutyUi extends UI {
  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              'ON DUTY - Started ${_formatTime(state.duties.activeDuty?.startTime ?? DateTime.now())}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (state.duties.dutyDuration != null) ...[
          const SizedBox(height: 8),
          Text(
            'Duration: ${state.duties.dutyDuration!.inHours}h ${state.duties.dutyDuration!.inMinutes % 60}m',
            style: const TextStyle(color: Colors.green),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              apply(
                ShowDialog(
                  (_, _, _) => AlertDialog(
                    title: const Text('End Your Shift'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Are you sure you want to end your current shift?',
                        ),
                        if (state.duties.dutyDuration != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Shift duration: ${state.duties.dutyDuration!.inHours}h ${state.duties.dutyDuration!.inMinutes % 60}m',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Shift notes (optional)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            // Store final notes if needed
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => apply(NavigateBack()),
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          apply(EndDuty());
                          apply(NavigateBack());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('END SHIFT'),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.stop_circle, size: 16),
            label: const Text('End Duty'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _OffDuty extends UI {
  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.circle_outlined, color: Colors.grey, size: 20),
            SizedBox(width: 8),
            Text(
              'OFF DUTY',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Start your shift:', style: TextStyle(fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                apply(
                  ShowDialog(
                    (_, _, _) => AlertDialog(
                      title: const Text('Start Duty'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Are you sure you want to start your duty?',
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Notes (optional)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 3,
                            onChanged: (value) {
                              // Store notes if needed
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => apply(NavigateBack()),
                          child: const Text('CANCEL'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            apply(StartDuty(DateTime.now()));
                            apply(NavigateBack());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('START SHIFT'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text('START'),
            ),
          ],
        ),
      ],
    );
  }
}
