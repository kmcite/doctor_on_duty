import 'package:doctor_on_duty/domain/api/cases_repository.dart';
import 'package:doctor_on_duty/domain/models/case.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/ui/case.dart';

final indexRM = RM.inject(() => 0);

class CasesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Cases'.text(),
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.x),
            onPress: navigator.back,
          ),
        ],
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.plus),
            onPress: () {
              casesRepository.put(Caze());
            },
          )
        ],
      ),
      child: [
        OpdCases(),
        EmergencyCases(),
      ][indexRM.state],
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
          )
        ],
      ),
    );
  }
}

class OpdCases extends StatelessWidget {
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
