import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerical/model/product.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Product> shirt = [];
  Product? shirtData;
  List<Product> dress =[];
  Product? dressData;
  List<Product> shoes =[];
  Product? shoesData;
  List<Product> pant =[];
  Product? pantData;
  List<Product> tie =[];
  Product? tieData;



  Future<void> getShirtData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("category")
        .doc("ZITKuL6SpEr9vvWPijS7")
        .collection("shirt")
        .get();
    for (var element in shirtSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product shirtData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(shirtData);
    }
    shirt = newList;
    notifyListeners();
  }

  List<Product> get getShirtList {
    return shirt;
  }

  Future<void> getDressData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("category")
        .doc("ZITKuL6SpEr9vvWPijS7")
        .collection("dress")
        .get();
    for (var element in shirtSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product shirtData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(shirtData);
    }
    dress = newList;
    notifyListeners();
  }

  List<Product> get getDressList {
    return dress;
  }

  Future<void> getShoesData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("category")
        .doc("ZITKuL6SpEr9vvWPijS7")
        .collection("shoes")
        .get();
    for (var element in shirtSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product shirtData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(shirtData);
    }
    shoes = newList;
    notifyListeners();
  }

  List<Product> get getshoesList {
    return shoes;
  }

  Future<void> getPantData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("category")
        .doc("ZITKuL6SpEr9vvWPijS7")
        .collection("pant")
        .get();
    for (var element in shirtSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product shirtData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(shirtData);
    }
    pant = newList;
    notifyListeners();
  }

  List<Product> get getPantList {
    return pant;
  }

  Future<void> getTieData() async {
    List<Product> newList = [];
    QuerySnapshot shirtSnapShot =
    await FirebaseFirestore.instance
        .collection("category")
        .doc("ZITKuL6SpEr9vvWPijS7")
        .collection("tie")
        .get();
    for (var element in shirtSnapShot.docs) {
      var data = element.data() as Map<String, dynamic>;
      Product shirtData = Product(
        image: data["image"],
        name: data["name"],
        price: data["price"],
      );
      newList.add(shirtData);
    }
    tie = newList;
    notifyListeners();
  }

  List<Product> get getTieList {
    return tie;
  }
}
//4142