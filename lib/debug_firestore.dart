import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> debugFirestoreReads() async {
  Future<void> tryRead(String path) async {
    try {
      final snap =
      await FirebaseFirestore.instance.collection(path).limit(1).get();
      print('READ OK  : $path -> ${snap.docs.length} docs');
    } catch (e) {
      print('READ FAIL: $path -> $e');
    }
  }

  // Thử các collection bạn đang có trong Firestore (theo ảnh)
  await tryRead('products');
  await tryRead('category');
  await tryRead('homefeature');
  await tryRead('homeachive');
  await tryRead('orders');
  await tryRead('users');
}