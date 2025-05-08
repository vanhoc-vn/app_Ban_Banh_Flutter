import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../screens/homepage.dart';

class ProductProvider with ChangeNotifier {
  List<Product> feature =[];
  Product? featureData;

  Future<void> getFutureData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("products")
        .doc("qtZQegLgnUOMbI9WRusO")
        .collection("featureproduct")
        .get();
    for (var element in shirtSnapShot.docs) {
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

  List<Product> get getShirtList {
    return feature;
  }

  List<Product> newAchives =[];
  Product? newAchiveData;

  Future<void> getNewAchiveData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("products")
        .doc("qtZQegLgnUOMbI9WRusO")
        .collection("featureproduct")
        .get();
    for (var element in shirtSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product newAchiveData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(newAchiveData);
    }
    newAchives = newList;
    notifyListeners();
  }

  List<Product> get getNewAchivesList {
    return newAchives;
  }





}