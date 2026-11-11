import 'package:doctor_on_duty/domain/case_workflow.dart';
import 'package:doctor_on_duty/domain/models/case_catalog.dart';
import 'package:objectbox/objectbox.dart';

import 'duty.dart';
import 'model.dart';

@Entity()
class Patient extends Model {
  @override
  @Id()
  int id = 0;

  String patientName = '';
  int age = 0;
  String gender = '';

  /// When the patient was seen / logged (search by date & time).
  @Property(type: PropertyType.date)
  DateTime arrivedAt = DateTime.now();

  String complaint = '';
  String duration = '';

  /// PMH / drugs / allergies / context (step 1).
  String history = '';

  /// [CaseWorkflow] step: biodata → examination → management → complete.
  String caseStatus = CaseWorkflow.biodata;

  /// Legacy single type; superseded by [categories].
  String category = '';

  /// [CaseType] ids (multi-select).
  List<String> categories = [];

  /// On examination (O/E) findings.
  String examination = '';

  /// Relative paths under app documents (MLC / autopsy photos).
  String imagePaths = '';

  String treatmentRoute = '';

  String medsAdvice = '';

  String disposition = '';

  /// FIR / MLC ref / ward slip (MLC, firearm, autopsy).
  String legalReference = '';

  /// Legacy ObjectBox field; no longer edited in UI.
  @Property(type: PropertyType.date)
  DateTime? eventDateTime;

  final duty = ToOne<Duty>();

  Patient();

  bool get isMlcCase => categories.contains(CaseType.mlcAutopsy);

  bool get isCaseComplete => caseStatus == CaseWorkflow.complete;

  String get caseCompletionLabel => isCaseComplete ? 'Complete' : 'Incomplete';

  bool get canMarkComplete => !isCaseComplete && managementDocument.trim().isNotEmpty;

  List<String> get attachmentPaths => imagePaths
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  set attachmentPaths(List<String> paths) =>
      imagePaths = paths.where((p) => p.isNotEmpty).join(',');

  String get displayName =>
      patientName.isNotEmpty ? patientName : 'Unnamed';

  String get presentationLine {
    final text = hxDocument.trim();
    if (text.isEmpty) return '';
    if (text.length <= 140) return text;
    return '${text.substring(0, 140)}…';
  }

  /// Biodata / chief complaint + context (free text).
  String get hxDocument {
    if (history.trim().isNotEmpty) return history;
    final parts = <String>[];
    if (complaint.trim().isNotEmpty) parts.add(complaint.trim());
    if (duration.trim().isNotEmpty) parts.add('(${duration.trim()})');
    return parts.join(' ');
  }

  /// Free text or legacy dropdown value for UI.
  String get treatmentRouteDisplay {
    final v = treatmentRoute.trim();
    if (v.isEmpty || v == TreatmentRoute.none) return '';
    if (TreatmentRoute.all.contains(v)) return TreatmentRoute.label(v);
    return v;
  }

  String get dispositionDisplay {
    final v = disposition.trim();
    if (v.isEmpty || v == Disposition.pending) return '';
    if (Disposition.all.contains(v)) return Disposition.label(v);
    return v;
  }

  /// Free-text management plan (merged route, meds, disposition in UI).
  String get managementDocument {
    final parts = <String>[];
    final route = treatmentRoute.trim();
    if (route.isNotEmpty) {
      parts.add(
        TreatmentRoute.all.contains(route) ? TreatmentRoute.label(route) : route,
      );
    }
    if (medsAdvice.trim().isNotEmpty) parts.add(medsAdvice.trim());
    final disp = disposition.trim();
    if (disp.isNotEmpty) {
      parts.add(Disposition.all.contains(disp) ? Disposition.label(disp) : disp);
    }
    return parts.join('\n\n');
  }
}
