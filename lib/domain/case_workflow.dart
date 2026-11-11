/// Step-by-step case documentation.
abstract final class CaseWorkflow {
  static const biodata = 'biodata';
  static const examination = 'examination';
  static const management = 'management';
  static const complete = 'complete';

  static const steps = [biodata, examination, management, complete];

  static int indexOf(String status) {
    final i = steps.indexOf(status);
    return i < 0 ? 0 : i;
  }

  static String? next(String status) {
    final i = indexOf(status);
    if (i >= steps.length - 1) return null;
    return steps[i + 1];
  }

  static String label(String status) => switch (status) {
        biodata => '1 · Biodata / Hx',
        examination => '2 · O/E',
        management => '3 · Management',
        complete => 'Complete',
        _ => status,
      };

  static bool isDraft(String status) => status != complete;
}
