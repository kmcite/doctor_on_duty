import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/domain/api/symptoms_repository.dart';
import 'package:doctor_on_duty/domain/models/symptom.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/search_symptoms.dart';

class SymptomsPage extends StatefulWidget {
  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  late SymptomsRepository symptomsRepository = watch();
  void put(Symptom symptom) async {
    symptomsRepository.put(symptom);
  }

  List<Symptom> get symptoms => symptomsRepository.getAll();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Symptoms'.text(),
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.arrowLeft),
          ),
        ],
        suffixes: [
          FButton.icon(
            onPress: () {
              // navigator.toNamed(SearchSymptomPage.path);
              navigator.to(SearchSymptomPage());
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
      child:
          // symptomsBlocRM.state.symptomsRM.isWaiting
          //     ? CircularProgressIndicator().center()
          //     :
          RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: symptoms.length,
          itemBuilder: (context, index) {
            final symptom = symptoms[index];
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
