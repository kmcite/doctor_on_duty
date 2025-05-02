import 'package:doctor_on_duty/domain/api/navigator.dart';
import '../../main.dart';
import 'symptoms_bloc.dart';

class SymptomsPage extends UI {
  static const path = '/symptoms_page';
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Symptoms'.text(),
        prefixActions: [
          FButton.icon(
            onPress: navigator.back,
            child: FIcon(FAssets.icons.arrowLeft),
          ),
        ],
        suffixActions: [
          FButton.icon(
            onPress: () {
              // navigator.toNamed(SearchSymptomPage.path);
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
      content:
          // symptomsBlocRM.state.symptomsRM.isWaiting
          //     ? CircularProgressIndicator().center()
          //     :
          RefreshIndicator(
        onRefresh: symptomsBlocRM.state.symptomsRM.refresh,
        child: ListView.builder(
          itemCount: symptomsBlocRM.state.symptoms.length,
          itemBuilder: (context, index) {
            final symptom = symptomsBlocRM.state.symptoms[index];
            return ListTile(
              title: symptom.name.toString().text(),
              onTap: () {
                // navigator.toNamed(
                //   SymptomPage.path,
                //   arguments: symptom,
                // );
              },
            );
          },
        ),
      ),
      //  FloatingActionButton(
      //   onPressed: () {
      //     navigator.toNamed(
      //       EditSymptomPage.path,
      //       arguments: Symptom(),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
