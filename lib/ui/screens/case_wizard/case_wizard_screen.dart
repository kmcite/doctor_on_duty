import 'dart:io';

import 'package:doctor_on_duty/business/duties.dart';
import 'package:doctor_on_duty/domain/case_workflow.dart';
import 'package:doctor_on_duty/domain/models/case_catalog.dart';
import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/domain/services/case_attachment_service.dart';
import 'package:doctor_on_duty/domain/services/store_service.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/theme/liquid_glass.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_buttons.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CaseWizardArgs {
  const CaseWizardArgs({this.patientId, this.startStep});

  final int? patientId;
  final String? startStep;
}

String _sexFromStored(String raw) {
  final g = raw.trim().toLowerCase();
  if (g == 'm' || g == 'male') return 'M';
  if (g == 'f' || g == 'female') return 'F';
  return 'unspecified';
}

String _sexToStored(Set<String> selected) {
  final v = selected.single;
  return v == 'unspecified' ? '' : v;
}

/// Biodata → O/E → Management (+ MLC/autopsy photos).
class CaseWizardScreen extends StatefulWidget {
  const CaseWizardScreen({super.key, this.patientId, this.startStep});

  final int? patientId;
  final String? startStep;

  @override
  State<CaseWizardScreen> createState() => _CaseWizardScreenState();
}

class _CaseWizardScreenState extends State<CaseWizardScreen> {
  final _page = PageController();
  final _attachments = const CaseAttachmentService();
  final _picker = ImagePicker();

  int _stepIndex = 0;
  int? _caseId;
  bool _loading = false;
  bool _suppressPageValidation = false;

  final _name = TextEditingController();
  final _age = TextEditingController();
  Set<String> _sex = {'unspecified'};
  final Set<String> _caseTypes = {};
  final _history = TextEditingController();
  final _examination = TextEditingController();
  final _management = TextEditingController();
  final _legalRef = TextEditingController();

  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    if (widget.patientId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load(widget.patientId!));
    } else if (widget.startStep != null) {
      _stepIndex = CaseWorkflow.indexOf(widget.startStep!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_page.hasClients) _page.jumpToPage(_stepIndex);
    });
  }

  void _load(int id) {
    final store = context.read<StoreService>();
    final p = store.store?.box<Patient>().get(id);
    if (p == null) return;
    _caseId = p.id;
    _name.text = p.patientName;
    _age.text = p.age > 0 ? '${p.age}' : '';
    _sex = {_sexFromStored(p.gender)};
    _caseTypes
      ..clear()
      ..addAll(CaseType.fromStored(p.categories, legacyCategory: p.category));
    _history.text = p.hxDocument;
    _examination.text = p.examination;
    _management.text = p.managementDocument;
    _legalRef.text = p.legalReference;
    _imagePaths = p.attachmentPaths;
    _stepIndex = CaseWorkflow.indexOf(p.caseStatus);
    if (_stepIndex >= CaseWorkflow.steps.length) {
      _stepIndex = CaseWorkflow.steps.length - 1;
    }
    setState(() {});
    if (_page.hasClients) _page.jumpToPage(_stepIndex);
  }

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    _age.dispose();
    _history.dispose();
    _examination.dispose();
    _management.dispose();
    _legalRef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidScaffold(
      appBar: AppBar(
        title: Text(_caseId == null ? 'New case' : 'Case #$_caseId'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: _StepHeader(
            current: _stepIndex,
            onStepTap: _jumpToStep,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _page,
              onPageChanged: _onPageChanged,
              children: [
                _buildBiodataStep(),
                _buildExamStep(),
                _buildManagementStep(),
              ],
            ),
          ),
          _buildNavBar(),
        ],
      ),
    );
  }

  Widget _buildBiodataStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        const _StepIntro(
          title: 'Biodata & history',
          requiredNote: '',
          optionalNote: 'Name, age, sex, case type, and Hx optional.',
        ),
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 112,
              child: TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Sex'),
                child: SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 'M', label: Text('M')),
                    ButtonSegment(value: 'F', label: Text('F')),
                    ButtonSegment(
                      value: 'unspecified',
                      label: Text('U'),
                      tooltip: 'Unspecified',
                    ),
                  ],
                  selected: _sex,
                  onSelectionChanged: (v) => setState(() => _sex = v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Case type',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final id in CaseType.all)
              LiquidChoiceChip(
                label: CaseType.label(id),
                selected: _caseTypes.contains(id),
                onSelected: (on) => setState(() {
                  if (on) {
                    _caseTypes.add(id);
                  } else {
                    _caseTypes.remove(id);
                    if (id == CaseType.mlcAutopsy) _legalRef.clear();
                  }
                }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _history,
          decoration: const InputDecoration(
            labelText: 'Hx',
            hintText: 'Chief complaint, duration, PMH, meds, allergy, context…',
            alignLabelWithHint: true,
          ),
          minLines: 4,
          maxLines: 12,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildExamStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        const _StepIntro(
          title: 'On examination (O/E)',
          requiredNote: 'Recommended before management.',
          optionalNote: 'GCS, vitals, local & systemic exam.',
        ),
        TextField(
          controller: _examination,
          decoration: const InputDecoration(
            labelText: 'O/E',
            hintText: 'GCS 15/15, BP…, chest clear, abdomen soft…',
            alignLabelWithHint: true,
          ),
          minLines: 4,
          maxLines: 12,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  bool get _isMlcCase => _caseTypes.contains(CaseType.mlcAutopsy);

  Widget _buildManagementStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        const _StepIntro(
          title: 'Management',
          requiredNote: '',
          optionalNote:
              'Treatment, meds/advice, disposition. Photos & MLC ref when needed.',
        ),
        TextField(
          controller: _management,
          decoration: const InputDecoration(
            labelText: 'Treatment / meds / advice / disposition',
            hintText:
                'Route, prescriptions, counselling, discharge / refer / admit…',
            alignLabelWithHint: true,
          ),
          minLines: 4,
          maxLines: 12,
          textCapitalization: TextCapitalization.sentences,
        ),
        if (_isMlcCase) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Legal / MLC',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _legalRef,
            decoration: const InputDecoration(labelText: 'FIR / MLC ref'),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Text(
          'Photos',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final rel in _imagePaths)
              _PhotoThumb(rel: rel, onRemove: () => _removeImage(rel)),
            LiquidActionChip(
              icon: Icons.add_a_photo,
              label: 'Add photo',
              onPressed: _loading ? null : _promptAddPhoto,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavBar() {
    return LiquidBar(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Row(
          children: [
            if (_stepIndex > 0)
              LiquidButton(
                variant: LiquidButtonVariant.ghost,
                label: 'Back',
                onPressed: _loading ? null : _back,
              )
            else
              LiquidButton(
                variant: LiquidButtonVariant.ghost,
                label: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            const Spacer(),
            if (_stepIndex < 2)
              TextButton(
                onPressed: _loading ? null : _advanceStep,
                child: const Text('Next'),
              ),
            const SizedBox(width: AppSpacing.sm),
            LiquidButton(
              label: 'Save',
              onPressed: _loading ? null : _save,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _promptAddPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              subtitle: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    await _pickAndSavePhoto(source);
  }

  Future<void> _pickAndSavePhoto(ImageSource source) async {
    if (_caseId == null) {
      final ok = await _persist(CaseWorkflow.steps[_stepIndex], pop: false);
      if (!ok || _caseId == null) return;
    }
    final id = _caseId!;
    try {
      final x = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2560,
      );
      if (x == null) return;
      final rel = await _attachments.saveImage(File(x.path), id);
      if (!mounted) return;
      setState(() => _imagePaths = [..._imagePaths, rel]);
      await _persist(CaseWorkflow.management, pop: false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add photo: $e')),
      );
    }
  }

  Future<void> _removeImage(String rel) async {
    await _attachments.deleteRelative(rel);
    setState(() => _imagePaths = _imagePaths.where((p) => p != rel).toList());
    await _persist(CaseWorkflow.management, pop: false);
  }

  void _jumpToStep(int i) {
    if (i == _stepIndex || i < 0 || i > 2) return;
    _page.animateToPage(
      i,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Future<void> _onPageChanged(int i) async {
    if (_suppressPageValidation) {
      setState(() => _stepIndex = i);
      return;
    }

    final from = _stepIndex;
    if (i == from) return;

    if (i > from) {
      final ok = await _persist(CaseWorkflow.steps[i], pop: false);
      if (!ok) {
        _suppressPageValidation = true;
        await _page.animateToPage(
          from,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
        if (mounted) _suppressPageValidation = false;
        return;
      }
    }

    if (mounted) setState(() => _stepIndex = i);
  }

  void _back() {
    if (_stepIndex == 0) return;
    _suppressPageValidation = true;
    _page
        .animateToPage(
          _stepIndex - 1,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        )
        .whenComplete(() {
      if (mounted) _suppressPageValidation = false;
    });
  }

  Future<void> _advanceStep() async {
    if (_stepIndex >= 2) return;
    final nextStatus = CaseWorkflow.steps[_stepIndex + 1];
    final ok = await _persist(nextStatus, pop: false);
    if (!ok || !mounted) return;
    final next = _stepIndex + 1;
    _suppressPageValidation = true;
    await _page.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
    if (mounted) {
      setState(() => _stepIndex = next);
      _suppressPageValidation = false;
    }
  }

  Future<void> _save() async {
    var status = CaseWorkflow.steps[_stepIndex];
    if (_stepIndex == 2 && _management.text.trim().isNotEmpty) {
      status = CaseWorkflow.complete;
    }
    await _persist(status, pop: true);
  }

  Future<bool> _persist(
    String status, {
    required bool pop,
    String? message,
  }) async {
    setState(() => _loading = true);
    try {
      final store = context.read<StoreService>();
      final duties = context.read<DutiesController>();
      Patient p;
      if (_caseId != null) {
        p = store.store!.box<Patient>().get(_caseId!) ?? Patient();
      } else {
        p = Patient()..arrivedAt = DateTime.now();
      }

      p
        ..patientName = _name.text.trim()
        ..age = int.tryParse(_age.text.trim()) ?? 0
        ..gender = _sexToStored(_sex)
        ..history = _history.text.trim()
        ..complaint = ''
        ..duration = ''
        ..category = ''
        ..categories = (_caseTypes.toList()..sort())
        ..examination = _examination.text.trim()
        ..treatmentRoute = ''
        ..medsAdvice = _management.text.trim()
        ..disposition = ''
        ..legalReference =
            _caseTypes.contains(CaseType.mlcAutopsy) ? _legalRef.text.trim() : ''
        ..caseStatus = status
        ..attachmentPaths = _imagePaths;

      if (p.id == 0 && duties.isOnDuty) {
        final session = duties.ensureTodaySession();
        store.put(session);
        if (session.id != 0) p.duty.targetId = session.id;
      }

      final id = store.put(p);
      p.id = id;
      _caseId = id;

      if (mounted && message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
      if (mounted && pop) Navigator.pop(context, id);
      return true;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.current, this.onStepTap});

  final int current;
  final ValueChanged<int>? onStepTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: List.generate(3, (i) {
          final active = i == current;
          final done = i < current;
          final color = active
              ? Theme.of(context).colorScheme.primary
              : done
                  ? AppColors.onDuty
                  : Theme.of(context).colorScheme.outline;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: onStepTap == null ? null : () => onStepTap!(i),
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CaseWorkflow.label(CaseWorkflow.steps[i]),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
          );
        }),
      ),
    );
  }
}

class _StepIntro extends StatelessWidget {
  const _StepIntro({
    required this.title,
    required this.requiredNote,
    required this.optionalNote,
  });

  final String title;
  final String requiredNote;
  final String optionalNote;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (requiredNote.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              requiredNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          if (optionalNote.isNotEmpty) ...[
            if (requiredNote.isNotEmpty) const SizedBox(height: 2),
            Text(optionalNote, style: LiquidGlass.bodySecondary(context)),
          ],
        ],
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.rel, required this.onRemove});

  final String rel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: CaseAttachmentService().resolveFile(rel),
      builder: (context, snap) {
        final file = snap.data;
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: file != null
                    ? Image.file(file, fit: BoxFit.cover)
                    : const ColoredBox(color: Colors.black12),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(28, 28),
                ),
                iconSize: 16,
                onPressed: onRemove,
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        );
      },
    );
  }
}
