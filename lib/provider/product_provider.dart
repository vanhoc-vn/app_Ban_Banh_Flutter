import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/cartmodel.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  // --- DANH SÁCH SẢN PHẨM ---
  List<Product> feature = [];
  List<Product> homeFeature = [];
  List<Product> homeAchive = [];
  List<Product> newAchives = [];

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- QUẢN LÝ GIỎ HÀNG ---
  final List<CartModel> _cartModelList = [];
  List<CartModel> get getCartModelList => _cartModelList;
  int get getCartModelListLength => _cartModelList.length;

  // --- LOGIC GỘP TẤT CẢ SẢN PHẨM (MỚI) ---
  // Getter này gộp tất cả các danh sách lại thành một để hiển thị toàn bộ menu
  List<Product> get getAllProductsList {
    return [
      ...homeFeature,
      ...homeAchive,
      ...feature,
      ...newAchives,
    ];
  }

  // Thêm sản phẩm vào giỏ hàng
  void getCartData({String? name, String? image, int? quantity, double? price}) {
    if (name != null && image != null && quantity != null && price != null) {
      _cartModelList.add(
        CartModel(price: price, name: name, image: image, quantity: quantity),
      );
      notifyListeners();
    }
  }

  // Cập nhật số lượng hoặc xóa sản phẩm khỏi giỏ
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

  // --- TRUY VẤN FIREBASE ---
  static const _rootProductsDocId = "qtZQegLgnUOMbI9WRusO";

  // Hàm tải tất cả dữ liệu cùng lúc (Dùng cho trang Tất cả sản phẩm)
  Future<void> fetchAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Chạy song song các hàm fetch để tiết kiệm thời gian
      await Future.wait([
        getFutureData(),
        getHomeFeatureData(),
        getHomeAchiveData(),
        getNewAchiveData(),
      ]);
    } catch (e) {
      debugPrint("fetchAllData error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFutureData() async {
    final newList = <Product>[];
    try {
      final snap = await FirebaseFirestore.instance
          .collection("products")
          .doc(_rootProductsDocId)
          .collection("featureproduct")
          .get();

      for (final doc in snap.docs) {
        newList.add(Product.fromMap(doc.data()));
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
}