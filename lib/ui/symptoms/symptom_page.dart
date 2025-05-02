import 'package:doctor_on_duty/domain/models/symptom.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:flutter/cupertino.dart';

class SymptomPage extends UI {
  static const path = '/symptom_page';

  @override
  Widget build(BuildContext context) {
    final symptom = context.routeData.arguments as Symptom;
    return Scaffold(
      appBar: AppBar(
        title: symptom.name.text(),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              // navigator.toNamed(EditSymptomPage.path, arguments: symptom);
            },
            icon: Icon(Icons.edit),
          ).pad(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CupertinoButton.filled(
            onPressed: () {},
            child: Text('${symptom.description}'),
          ).pad(),
          CupertinoButton.filled(
            onPressed: () {},
            child: Text('${symptom.investigations}'),
          ).pad(),
          CupertinoButton.filled(
            onPressed: () {},
            child: Text('${symptom.examination}'),
          ).pad(),
          CupertinoButton.filled(
            onPressed: () {},
            child: Text('${symptom.differentials}'),
          ).pad(),
        ],
      ),
    );
  }
}
