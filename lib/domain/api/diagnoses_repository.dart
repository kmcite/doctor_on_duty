import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final diagnosesRepositoryRM = RM.inject(() => DiagnosesRepository());

class DiagnosesRepository {
  Future<Diagnosis?> get(String id) async {
    return null;

    // final document = await databases.getDocument(
    //   databaseId: DATABASE_ID,
    //   collectionId: DIAGNOSIS_COLLECTION_ID,
    //   documentId: id,
    // );
    // return Diagnosis.fromJson(document.data);
  }

  Future<List<Diagnosis>> getAll() async {
    // final documents = await databases.listDocuments(
    //   databaseId: DATABASE_ID,
    //   collectionId: DIAGNOSIS_COLLECTION_ID,
    // );
    // return documents.documents.map(
    //   (document) {
    //     return Diagnosis.fromJson(document.data);
    //   },
    // ).toList();
    return [];
  }

  Future<void> put(Diagnosis diagnosis) async {
    // try {
    //   await databases.updateDocument(
    //     databaseId: DATABASE_ID,
    //     collectionId: DIAGNOSIS_COLLECTION_ID,
    //     documentId: diagnosis.id,
    //     data: diagnosis.toJson(),
    //   );
    //   print('UPDATED ${diagnosis.id}');
    // } catch (e) {
    //   await databases.createDocument(
    //     data: diagnosis.toJson(),
    //     databaseId: DATABASE_ID,
    //     collectionId: DIAGNOSIS_COLLECTION_ID,
    //     documentId: diagnosis.id,
    //   );
    //   print('CREATED ${diagnosis.id}');
    // }
  }

  Future<void> delete(String id) async {
    // await databases.deleteDocument(
    //   databaseId: DATABASE_ID,
    //   collectionId: DIAGNOSIS_COLLECTION_ID,
    //   documentId: id,
    // );
  }
}
