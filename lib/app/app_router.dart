import 'package:doctor_on_duty/ui/screens/case_wizard/case_wizard_screen.dart';
import 'package:doctor_on_duty/ui/screens/duty_manager_screen.dart';
import 'package:doctor_on_duty/ui/screens/hub/hub.dart';
import 'package:doctor_on_duty/ui/screens/patient_details_screen.dart';
import 'package:doctor_on_duty/ui/screens/patients_screen.dart';
import 'package:doctor_on_duty/ui/screens/settings_screen.dart';
import 'package:doctor_on_duty/ui/screens/weekly_duty_setup_screen.dart';
import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static const hub = '/';
  static const settings = '/settings';
  static const patients = '/patients';
  static const patientDetails = '/patient';
  static const addPatient = '/add-patient';
  static const caseWizard = '/case-wizard';
  static const editPatient = '/edit-patient';
  static const dutyManager = '/duty-manager';
  static const dutySessionDetail = '/duty-session';

  /// Legacy paths — routed to [dutyManager].
  static const startDuty = '/start-duty';
  static const duty = '/duty';
  static const addDuty = '/add-duty';
  static const weeklyDutySetup = '/weekly-duty-setup';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.hub:
        return MaterialPageRoute(builder: (_) => const Hub());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.patients:
        return MaterialPageRoute(builder: (_) => const PatientsScreen());
      case AppRoutes.patientDetails:
        final id = settings.arguments! as int;
        return MaterialPageRoute(builder: (_) => PatientDetailsScreen(id));
      case AppRoutes.addPatient:
      case AppRoutes.caseWizard:
        final args = settings.arguments;
        if (args is CaseWizardArgs) {
          return MaterialPageRoute(
            builder: (_) => CaseWizardScreen(
              patientId: args.patientId,
              startStep: args.startStep,
            ),
            fullscreenDialog: true,
          );
        }
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => CaseWizardScreen(patientId: args),
            fullscreenDialog: true,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const CaseWizardScreen(),
          fullscreenDialog: true,
        );
      case AppRoutes.editPatient:
        final id = settings.arguments! as int;
        return MaterialPageRoute(
          builder: (_) => CaseWizardScreen(patientId: id),
          fullscreenDialog: true,
        );
      case AppRoutes.dutyManager:
        return MaterialPageRoute(builder: (_) => const DutyManagerScreen());
      case AppRoutes.startDuty:
      case AppRoutes.duty:
      case AppRoutes.addDuty:
        return MaterialPageRoute(builder: (_) => const DutyManagerScreen());
      case AppRoutes.weeklyDutySetup:
        final required = settings.arguments is bool
            ? settings.arguments! as bool
            : false;
        return MaterialPageRoute(
          builder: (_) => WeeklyDutySetupScreen(requiredSetup: required),
          fullscreenDialog: required,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Unknown route')),
          ),
        );
    }
  }
}

void openRoute(BuildContext context, String name, {Object? arguments}) {
  Navigator.of(context).pushNamed(name, arguments: arguments);
}
