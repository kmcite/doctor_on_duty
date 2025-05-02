import 'package:doctor_on_duty/domain/models/symptom.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final symptomsRepositoryRM = RM.inject(() => SymptomsRepository());

class SymptomsRepository {
  Future<Symptom?> get(String id) async {
    return null;

    // final document = await databases.getDocument(
    //   databaseId: DATABASE_ID,
    //   collectionId: SYMPTOMS_COLLECTION_ID,
    //   documentId: id,
    // );
    // return Symptom.fromJson(document.data);
  }

  Future<List<Symptom>> getAll() async {
    // final documents = await databases.listDocuments(
    //   databaseId: DATABASE_ID,
    //   collectionId: SYMPTOMS_COLLECTION_ID,
    // );
    // return documents.documents.map(
    //   (document) {
    //     return Symptom.fromJson(document.data);
    //   },
    // ).toList();
    return [];
  }

  Future<void> put(Symptom symptom) async {
    // try {
    //   await databases.updateDocument(
    //     databaseId: DATABASE_ID,
    //     collectionId: SYMPTOMS_COLLECTION_ID,
    //     documentId: symptom.id,
    //     data: symptom.toJson(),
    //   );
    //   print('UPDATED ${symptom.id}');
    // } catch (e) {
    //   await databases.createDocument(
    //     data: symptom.toJson(),
    //     databaseId: DATABASE_ID,
    //     collectionId: SYMPTOMS_COLLECTION_ID,
    //     documentId: symptom.id,
    //   );
    //   print('CREATED ${symptom.id}');
    // }
  }

  Future<void> delete(String id) async {
    // await databases.deleteDocument(
    //   databaseId: DATABASE_ID,
    //   collectionId: SYMPTOMS_COLLECTION_ID,
    //   documentId: id,
    // );
  }
}
