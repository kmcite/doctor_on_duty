import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/dark.dart';
import 'package:doctor_on_duty/business/duties.dart';
import 'package:doctor_on_duty/business/patients.dart';
import 'package:doctor_on_duty/domain/repositories/duties.dart';
import 'package:doctor_on_duty/domain/repositories/patients_repository.dart';
import 'package:doctor_on_duty/domain/services/store_service.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'dart:io';
export 'package:flutter/material.dart';
export 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await ThemeController.readPersistedDark();
  final storeService = StoreService();
  await storeService.init();
  final dutiesRepository = DutiesRepository(storeService);
  final patientsRepository = PatientsRepository(storeService);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storeService),
        ChangeNotifierProvider.value(value: dutiesRepository),
        ChangeNotifierProvider.value(value: patientsRepository),
        ChangeNotifierProvider(
          create: (context) => DutiesController(
            context.read<DutiesRepository>(),
            context.read<PatientsRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PatientsController(
            context.read<PatientsRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController(initialDark: isDark),
        ),
      ],
      child: const DoctorOnDutyApp(),
    ),
  );
}

class DoctorOnDutyApp extends StatelessWidget {
  const DoctorOnDutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    return MaterialApp(
      title: 'Doctor on Duty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.hub,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
