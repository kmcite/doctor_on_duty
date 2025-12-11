import 'package:doctor_on_duty/domain/api/cases_repository.dart';
import 'package:doctor_on_duty/domain/models/case.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/ui/caze.dart';

final indexRM = RM.inject(() => 0);

class CasesPage extends StatelessWidget {
  const CasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Cases'.text(),
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.x),
          ),
        ],
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.plus),
            onPress: () {
              casesRepository.put(Caze());
            },
          ),
        ],
      ),
      footer: FBottomNavigationBar(
        index: indexRM.state,
        onChange: (value) => indexRM.state = value,
        children: [
          FBottomNavigationBarItem(
            label: 'OPD'.text(),
            icon: Icon(FIcons.house),
          ),
          FBottomNavigationBarItem(
            label: 'Emergency'.text(),
            icon: Icon(FIcons.paintbrush),
          ),
        ],
      ),
      child: [
        OpdCases(),
        EmergencyCases(),
      ][indexRM.state],
    );
  }
}

class OpdCases extends StatelessWidget {
  const OpdCases({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        casesRepository.count(),
        (index) {
          final caze = casesRepository.getAll().elementAt(index);
          return FTile(
            title: caze.text(),
            onPress: () {
              navigator.to(CazePage(caze: caze));
            },
          );
        },
      ),
    );
  }
}

class EmergencyCases extends StatelessWidget {
  const EmergencyCases({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        40,
        (index) => FTile(
          title: 'Emergency Case $index'.text(),
          onPress: () {},
        ),
      ),
    );
  }
}
