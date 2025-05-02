import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

class DiagnosisPage extends UI {
  static const path = '/diagnosis_page';

  @override
  Widget build(BuildContext context) {
    final diagnosis = context.routeData.arguments as Diagnosis;
    return FScaffold(
      header: FHeader(
        title: diagnosis.name.text(),
        actions: [
          FButton.icon(
            onPress: () {
              navigator.back();
            },
            child: FIcon(FAssets.icons.arrowLeft),
          ),
          FButton.icon(
            onPress: () {
              // navigator.toNamed(EditDiagnosisPage.path, arguments: diagnosis);
            },
            child: FIcon(FAssets.icons.pen),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FAccordion(
            controller: FAccordionController(max: 3),
            items: [
              FAccordionItem(
                title: 'symptoms'.text(),
                child: diagnosis.symptoms.text(),
              ),
              FAccordionItem(
                title: 'description'.text(),
                child: diagnosis.description.text(),
              ),
              FAccordionItem(
                title: 'examination'.text(),
                child: diagnosis.examination.text(),
              ),
              FAccordionItem(
                title: 'investigations'.text(),
                child: diagnosis.investigations.text(),
              ),
              FAccordionItem(
                title: 'differentials'.text(),
                child: diagnosis.differentials.text(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
