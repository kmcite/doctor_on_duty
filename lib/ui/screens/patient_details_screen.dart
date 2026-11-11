import 'dart:io';

import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/patients.dart';
import 'package:doctor_on_duty/domain/case_workflow.dart';
import 'package:doctor_on_duty/domain/models/case_catalog.dart';
import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/domain/services/case_attachment_service.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen(this.patientId, {super.key});

  final int patientId;

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientsController>().byId(patientId);

    if (patient == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.maybePop(context);
      });
      return const Scaffold(
        body: Center(child: Text('Case not found')),
      );
    }

    return LiquidScaffold(
      appBar: AppBar(
        title: Text(patient.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, patient),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => openRoute(
              context,
              AppRoutes.editPatient,
              arguments: patientId,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          if (!patient.isCaseComplete) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: FilledButton.icon(
                onPressed: () => openRoute(
                  context,
                  AppRoutes.editPatient,
                  arguments: patientId,
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit & save'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          _Section(
            title: 'Status',
            children: [
              _row('Case', patient.caseCompletionLabel),
              if (!patient.isCaseComplete)
                _row('Step', CaseWorkflow.label(patient.caseStatus)),
            ],
          ),
          _Section(
            title: 'Identity',
            children: [
              _row('Name', patient.displayName),
              if (patient.age > 0) _row('Age', '${patient.age}'),
              if (patient.gender.isNotEmpty) _row('Sex', patient.gender),
              _row('Seen at', DateFormat.yMMMd().add_Hm().format(patient.arrivedAt)),
            ],
          ),
          if (CaseType.labelsFor(patient.categories).isNotEmpty)
            _Section(
              title: 'Case type',
              children: [
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final label in CaseType.labelsFor(patient.categories))
                      Chip(
                        label: Text(label),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ),
          _Section(
            title: 'Presentation',
            children: [
              if (patient.hxDocument.isNotEmpty)
                _multiline(patient.hxDocument)
              else
                Text(
                  'No Hx recorded',
                  style: LiquidGlass.bodyTertiary(context),
                ),
            ],
          ),
          _Section(
            title: 'O/E',
            children: [
              if (patient.examination.isNotEmpty)
                _multiline(patient.examination)
              else
                Text(
                  'Not recorded',
                  style: LiquidGlass.bodyTertiary(context),
                ),
            ],
          ),
          _Section(
            title: 'Management',
            children: [
              if (patient.managementDocument.isNotEmpty)
                _multiline(patient.managementDocument)
              else
                Text(
                  'Not recorded',
                  style: LiquidGlass.bodyTertiary(context),
                ),
            ],
          ),
          if (patient.isMlcCase)
            _Section(
              title: 'Legal',
              children: [
                if (patient.legalReference.isNotEmpty)
                  _row('Reference', patient.legalReference)
                else
                  Text(
                    'No FIR / MLC reference',
                    style: LiquidGlass.bodyTertiary(context),
                  ),
              ],
            ),
          if (patient.attachmentPaths.isNotEmpty)
            _Section(
              title: 'Photos',
              children: [
                _CasePhotoGrid(paths: patient.attachmentPaths),
              ],
            ),
          if (patient.duty.target != null)
            _Section(
              title: 'Duty shift',
              children: [
                _row(
                  'Session',
                  DateFormat.yMMMd().format(patient.duty.target!.date),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Patient patient) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete case?'),
        content: Text('Remove ${patient.displayName} permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    context.read<PatientsController>().removePatient(patient.id);
    if (context.mounted) Navigator.pop(context);
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  Widget _multiline(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text),
      );
}

class _CasePhotoGrid extends StatelessWidget {
  const _CasePhotoGrid({required this.paths});

  final List<String> paths;
  static final _svc = CaseAttachmentService();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: paths.map((rel) {
        return FutureBuilder<File?>(
          future: _svc.resolveFile(rel),
          builder: (context, snap) {
            final f = snap.data;
            if (f == null) return const SizedBox.shrink();
            return GestureDetector(
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => Dialog(
                  child: InteractiveViewer(child: Image.file(f)),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(f, width: 96, height: 96, fit: BoxFit.cover),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}
