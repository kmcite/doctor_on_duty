/// Case classification on biodata (multi-select).
abstract final class CaseType {
  static const medical = 'medical';
  static const peds = 'peds';
  static const surgical = 'surgical';
  static const mlcAutopsy = 'mlc_autopsy';
  static const antiRabies = 'anti_rabies';

  static const all = [
    medical,
    peds,
    surgical,
    mlcAutopsy,
    antiRabies,
  ];

  static String label(String value) => switch (value) {
        medical => 'Medical',
        peds => 'Peds',
        surgical => 'Surgical',
        mlcAutopsy => 'MLC / autopsy',
        antiRabies => 'Anti rabies vaccine candidate',
        _ => value,
      };

  static List<String> labelsFor(Iterable<String> stored) =>
      stored.where(all.contains).map(label).toList();

  static Set<String> fromStored(
    List<String> raw, {
    String legacyCategory = '',
  }) {
    final set = raw.where(all.contains).toSet();
    if (set.isEmpty &&
        legacyCategory.isNotEmpty &&
        all.contains(legacyCategory)) {
      set.add(legacyCategory);
    }
    return set;
  }
}

/// Legacy enum values for reading old records (UI uses free text now).
abstract final class TreatmentRoute {
  static const none = 'none';
  static const oral = 'oral';
  static const ivIm = 'iv_im';
  static const both = 'both';

  static const all = [none, oral, ivIm, both];

  static String label(String value) => switch (value) {
        none => 'None yet',
        oral => 'Oral only',
        ivIm => 'IV / IM',
        both => 'Oral + IV/IM',
        _ => value,
      };
}

abstract final class Disposition {
  static const pending = 'pending';
  static const discharged = 'discharged';
  static const referredBkmc = 'referred_bkmc';
  static const admitted = 'admitted';
  static const mlcHold = 'mlc_hold';
  static const autopsyDone = 'autopsy';
  static const other = 'other';

  static const all = [
    pending,
    discharged,
    referredBkmc,
    admitted,
    mlcHold,
    autopsyDone,
    other,
  ];

  static String label(String value) => switch (value) {
        pending => 'In progress',
        discharged => 'Discharged',
        referredBkmc => 'Referred → BKMC',
        admitted => 'Admitted',
        mlcHold => 'MLC / legal hold',
        autopsyDone => 'Autopsy',
        other => 'Other',
        _ => value,
      };
}
