// import 'dart:async';

// import 'package:doctor_on_duty/domain/store.dart';
// import 'package:doctor_on_duty/main.dart';

// class OBModel<M extends Model> {
//   final box = store.state.store.box<M>();
//   late final itemsRM = RM.injectFuture(box.getAllAsync);

//   List<M> get items => box.getAll();

//   List<M> get state => itemsRM.state;

//   M? get(int id) => state.where((test) => test.id == id).firstOrNull;
//   Future<void> put(M any) async {
//     await itemsRM.setState(
//       (_) async {
//         await Future.delayed(Duration(seconds: 1));
//         await box.putAsync(any);
//         return await box.getAllAsync();
//       },
//     );
//   }

//   bool get loading => itemsRM.isWaiting;

//   Future<void> remove(int id) async {
//     await itemsRM.setState((_) async {
//       await Future.delayed(Duration(seconds: 1));
//       await box.removeAsync(id);
//       return await box.getAllAsync();
//     });
//   }

//   Future<void> removeAll() async {
//     await itemsRM.setState((_) async {
//       await Future.delayed(Duration(seconds: 1));
//       await box.removeAllAsync();
//       return await box.getAllAsync();
//     });
//   }
// }
