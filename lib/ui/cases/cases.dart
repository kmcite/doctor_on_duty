import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

mixin class CasesBloc {
  final indexRM = RM.inject(() => 0);
}

class CasesPage extends UI with CasesBloc {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Cases'.text(),
        prefixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.x),
            onPress: navigator.back,
          ),
        ],
      ),
      content: FTabs(
        initialIndex: indexRM.state,
        onPress: (value) => indexRM.state = value,
        tabs: [
          FTabEntry(
            label: 'OPD'.text(),
            content: 'opd'.text(),
          ),
          FTabEntry(
            label: 'Emergency'.text(),
            content: EmergencyCases(),
          ),
        ],
      ),
    );
  }
}

class EmergencyCases extends UI {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ListView(
        shrinkWrap: true,
        children: List.generate(
          40,
          (index) => FTile(
            title: 'Emergency Case $index'.text(),
            onPress: () {},
          ),
        ),
      ),
    );
  }
}
