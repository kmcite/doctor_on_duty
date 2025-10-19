import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

import '../../domain/models/symptom.dart';

class EditSymptomPage extends StatelessWidget {
  static const path = '/edit_symptom_page';

  @override
  Widget build(BuildContext context) {
    final symptom = context.routeData.arguments as Symptom;
    return Scaffold(
      appBar: AppBar(
        title: 'EDIT SYMPTOM'.text(),
        leading: BackButton(
          onPressed: navigator.back,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // navigator.back().then(
              //   (_) {
              //     return navigator.back().then(
              //       (_) {
              //         return symptomsBlocRM.state.put(symptom);
              //       },
              //     );
              //   },
              // );
            },
            icon: Icon(Icons.done),
          ).pad(
              // right: 8
              ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            initialValue: symptom.name,
            onChanged: (value) {
              symptom..name = value;
            },
          ).pad(),
          TextFormField(
            initialValue: symptom.description,
            onChanged: (value) {
              symptom..description = value;
            },
            maxLines: null,
          ).pad(),
          symptom.toJson().text().pad(),
        ],
      ),
    );
  }
}
