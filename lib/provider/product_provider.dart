import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/cartmodel.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> feature = [];
  Product? featureData;

  List<CartModel> cartModelList = [];
  late CartModel cartModel;

  void getCartData({String? name, String? image, int? quentity, double? price}) {
    if (name != null && image != null && quentity != null && price != null) {
      cartModel = CartModel(
        price: price,
        name: name,
        image: image,
        quentity: quentity,
      );
      cartModelList.add(cartModel);
      notifyListeners();
    } else {
      print("Warning: Some cart data is null and cannot be added.");
    }
  }

  List<CartModel> get getCartModelList => List.from(cartModelList);
  int get getCartModelListLength => cartModelList.length;


  Future<void> getFutureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
    await FirebaseFirestore.instance
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
    QuerySnapshot newAchivesSnapshot =
    await FirebaseFirestore.instance
        .collection("products")
        .doc("qtZQegLgnUOMbI9WRusO")
        .collection("newachives") // Changed to "newachives"
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
}
