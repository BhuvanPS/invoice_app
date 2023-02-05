import 'package:firebase_storage/firebase_storage.dart';

class FireBaseApi {
  static Future<List<String>> getDownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((e) => e.getDownloadURL()).toList());
  }

  static Future<List<FirebaseFiles>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final urls = await getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFiles(ref: ref, name: name, url: url);
          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}

class FirebaseFiles {
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFiles(
      {required this.ref, required this.name, required this.url});
}
