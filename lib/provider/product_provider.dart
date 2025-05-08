import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/cartmodel.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> feature = [];
  Product? featureData;

  List<CartModel> _cartModelList = [];
  List<CartModel> get getCartModelList => _cartModelList;
  int get getCartModelListLength => _cartModelList.length;

  void getCartData({String? name, String? image, int? quantity, double? price}) {
    if (name != null && image != null && quantity != null && price != null) {
      _cartModelList.add(CartModel(
        price: price,
        name: name,
        image: image,
        quantity: quantity,
      ));
      notifyListeners();
    } else {
      print("Warning: Some cart data is null and cannot be added.");
    }
  }

  Future<void> getFutureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot = await FirebaseFirestore.instance
        .collection("products")
        .doc("qtZQegLgnUOMbI9WRusO")
        .collection("featureproduct")
        .get();
    for (var element in featureSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product featureData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(featureData);
    }
    feature = newList;
    notifyListeners();
  }

  List<Product> get getFutureList {
    return feature;
  }

  List<Product> homeFeature = [];
  Product? homeFeatureData;

  Future<void> getHomeFeatureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
    await FirebaseFirestore.instance.collection("homefeature").get();
    for (var element in featureSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product featureData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(featureData);
    }
    homeFeature = newList;
    notifyListeners();
  }

  List<Product> get getHomeFutureList {
    return homeFeature;
  }

  List<Product> homeAchive = [];
  Product? homeAchiveData;

  Future<void> getHomeAchiveData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
    await FirebaseFirestore.instance.collection("homeachive").get();
    for (var element in featureSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product featureData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(featureData);
    }
    homeAchive = newList;
    notifyListeners();
  }

  List<Product> get getHomeAchiveList {
    return homeAchive;
  }

  List<Product> newAchives = [];
  Product? newAchivesData;

  Future<void> getNewAchiveData() async {
    List<Product> newList = [];
    QuerySnapshot newAchivesSnapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("qtZQegLgnUOMbI9WRusO")
        .collection("newachives")
        .get();
    for (var element in newAchivesSnapshot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product newAchivesData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(newAchivesData);
    }
    newAchives = newList;
    notifyListeners();
  }

  List<Product> get getNewAchiesList {
    return newAchives;
  }

  void updateQuantity(String itemName, int newQuantity) {
    // Tìm sản phẩm trong giỏ hàng theo tên.
    int index = _cartModelList.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      // Nếu sản phẩm được tìm thấy
      if (newQuantity > 0) {
        // Nếu số lượng mới lớn hơn 0, cập nhật số lượng.
        _cartModelList[index].quantity = newQuantity;
      } else {
        // Nếu số lượng mới là 0, xóa sản phẩm khỏi giỏ hàng.
        _cartModelList.removeAt(index);
      }
      notifyListeners(); // Báo cho các listener để rebuild UI.
    }
  }

  void clearCart() {
    _cartModelList.clear();
    notifyListeners();
  }
}

