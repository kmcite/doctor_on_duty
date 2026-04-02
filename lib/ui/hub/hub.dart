import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/patients/emergency_patients.dart';
import 'package:doctor_on_duty/ui/patients/patients.dart';
import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/ui/search_symptoms.dart';
import 'package:doctor_on_duty/ui/hub/today_duty_section.dart';
import 'package:doctor_on_duty/ui/hub/today_cases_section.dart';
import 'package:doctor_on_duty/ui/duties/duty_manager_page.dart';
import 'package:doctor_on_duty/ui/ui.dart';
import 'package:forui/forui.dart';
import 'package:doctor_on_duty/ui/settings.dart';

class Hub extends UI {
  const Hub({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text("HealthCare +"),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.settings),
            onPress: () => apply(NavigateTo((context) => SettingsPage())),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Date and Current Duty Section
          const TodayDutySection(),
          const SizedBox(height: 16),

          // Today's Cases Summary
          const TodayCasesSection(),
          const SizedBox(height: 16),

          // Navigation Menu
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.medical_information),
                  title: const Text("Cases"),
                  onTap: () => apply(NavigateTo((context) => PatientsScreen())),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.emergency),
                  title: const Text("Emergency"),
                  onTap: () {
                    apply(NavigateTo((context) => const EmergencyPatients()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text("Search"),
                  onTap: () {
                    apply(NavigateTo((context) => const UnifiedSearchPage()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text("Duty Manager"),
                  onTap: () {
                    apply(NavigateTo((_) => const DutyManagerPage()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text("Favorites"),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
