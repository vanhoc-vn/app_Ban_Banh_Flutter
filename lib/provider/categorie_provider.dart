import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerical/model/product.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Product> shirt = [];
  List<Product> dress = [];
  List<Product> shoes = [];
  List<Product> pant = [];
  List<Product> tie = [];

  // docId category root của bạn
  static const _categoryRootDocId = "ZITKuL6SpEr9vvWPijS7";

  Future<List<Product>> _readCategorySub(String sub) async {
    final newList = <Product>[];
    try {
      final snap = await FirebaseFirestore.instance
          .collection("category")
          .doc(_categoryRootDocId)
          .collection(sub)
          .get();

      for (final doc in snap.docs) {
        // Lấy dữ liệu và gán thêm ID từ Firestore vào Map
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        newList.add(Product.fromMap(data));
      }
    } catch (e) {
      debugPrint("Lỗi khi đọc sub-collection $sub: $e");
    }
    return newList;
  }

  Future<void> getShirtData() async {
    shirt = await _readCategorySub("shirt");
    notifyListeners(); // Thông báo để UI cập nhật
  }

  List<Product> get getShirtList => shirt;

  Future<void> getDressData() async {
    dress = await _readCategorySub("dress");
    notifyListeners();
  }

  List<Product> get getDressList => dress;

  Future<void> getShoesData() async {
    shoes = await _readCategorySub("shoes");
    notifyListeners();
  }

  List<Product> get getshoesList => shoes;

  Future<void> getPantData() async {
    pant = await _readCategorySub("pant");
    notifyListeners();
  }

  List<Product> get getPantList => pant;

  Future<void> getTieData() async {
    tie = await _readCategorySub("tie");
    notifyListeners();
  }

  List<Product> get getTieList => tie;
}