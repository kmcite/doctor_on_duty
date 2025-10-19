import 'package:doctor_on_duty/domain/models/settings.dart';
import 'package:doctor_on_duty/utils/repositories.dart';

final settingsRepository = SettingsRepository();

class SettingsRepository extends Repository<Settings> {
  bool dark = false;
  void toggleDarkness() {
    dark = !dark;
    notifyListeners();
  }

  get initialState => Settings();
}
