final services = <Type, dynamic>{};
void service<T>(T instance) {
  services[T] = instance;
}

// abstract class StorageService<T extends Storable<I>, I> {
//   final T Function(Map<String, dynamic> json) fromJson;
//   const StorageService({
//     required this.fromJson,
//     required this.path,
//   });
//   final String path;

//   Future<void> init() async {}

//   Iterable<T> getAll();
//   T? get(I id);
//   void put(T item);
//   void delete(I id);
//   void clear();
// }

// abstract class Storable<I> {
//   I get id;
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id.toString(),
//     };
//   }
// }
