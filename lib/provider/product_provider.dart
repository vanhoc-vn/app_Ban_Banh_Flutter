import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/cartmodel.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> feature = [];
  List<Product> homeFeature = [];
  List<Product> homeAchive = [];
  List<Product> newAchives = [];

  final List<CartModel> _cartModelList = [];
  List<CartModel> get getCartModelList => _cartModelList;
  int get getCartModelListLength => _cartModelList.length;

  void getCartData({String? name, String? image, int? quantity, double? price}) {
    if (name != null && image != null && quantity != null && price != null) {
      _cartModelList.add(
        CartModel(price: price, name: name, image: image, quantity: quantity),
      );
      notifyListeners();
    } else {
      debugPrint("Warning: Some cart data is null and cannot be added.");
    }
  }

  // Lưu ý: docId "qtZQegLgnUOMbI9WRusO" phải tồn tại trong products
  static const _rootProductsDocId = "qtZQegLgnUOMbI9WRusO";

  Future<void> getFutureData() async {
    final newList = <Product>[];
    try {
      final snap = await FirebaseFirestore.instance
          .collection("products")
          .doc(_rootProductsDocId)
          .collection("featureproduct")
          .get();

      for (final doc in snap.docs) {
        final data = doc.data();
        newList.add(Product.fromMap(data));
      }

      feature = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("getFutureData error: $e");
    }
  }

  List<Product> get getFutureList => feature;

  Future<void> getHomeFeatureData() async {
    final newList = <Product>[];
    try {
      final snap = await FirebaseFirestore.instance.collection("homefeature").get();
      for (final doc in snap.docs) {
        newList.add(Product.fromMap(doc.data()));
      }
      homeFeature = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("getHomeFeatureData error: $e");
    }
  }

  List<Product> get getHomeFutureList => homeFeature;

  Future<void> getHomeAchiveData() async {
    final newList = <Product>[];
    try {
      final snap = await FirebaseFirestore.instance.collection("homeachive").get();
      for (final doc in snap.docs) {
        newList.add(Product.fromMap(doc.data()));
      }
      homeAchive = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("getHomeAchiveData error: $e");
    }
  }

  List<Product> get getHomeAchiveList => homeAchive;

  Future<void> getNewAchiveData() async {
    final newList = <Product>[];
    try {
      final snap = await FirebaseFirestore.instance
          .collection("products")
          .doc(_rootProductsDocId)
          .collection("newachives")
          .get();

      for (final doc in snap.docs) {
        newList.add(Product.fromMap(doc.data()));
      }

      newAchives = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("getNewAchiveData error: $e");
    }
  }

  List<Product> get getNewAchiesList => newAchives;

  void updateQuantity(String itemName, int newQuantity) {
    final index = _cartModelList.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      if (newQuantity > 0) {
        _cartModelList[index].quantity = newQuantity;
      } else {
        _cartModelList.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartModelList.clear();
    notifyListeners();
  }
}