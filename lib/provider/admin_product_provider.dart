import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';

class AdminProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  // Thêm các danh sách mới
  List<Product> _featureProducts = [];
  List<Product> _newAchieveProducts = [];

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // Getters
  List<Product> get featureProducts => _featureProducts;
  List<Product> get newAchieveProducts => _newAchieveProducts;

  // Fetch all products
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("products").get();

      _products =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product(
              id: doc.id,
              name: data["name"] ?? '',
              price: (data["price"] ?? 0.0).toDouble(),
              description: data["description"] ?? '',
              image: data["image"] ?? '',
              isAvailable: data["isAvailable"] ?? true,
            );
          }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch feature products
  Future<void> fetchFeatureProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("products")
              .doc("qtZQegLgnUOMbI9WRusO")
              .collection("featureproduct")
              .get();

      _featureProducts =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product(
              id: doc.id,
              name: data["name"] ?? '',
              price: (data["price"] ?? 0.0).toDouble(),
              image: data["image"] ?? '',
              description: data["description"] ?? '',
            );
          }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch new achieve products
  Future<void> fetchNewAchieveProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("products")
              .doc("qtZQegLgnUOMbI9WRusO")
              .collection("newachives")
              .get();

      _newAchieveProducts =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product(
              id: doc.id,
              name: data["name"] ?? '',
              price: (data["price"] ?? 0.0).toDouble(),
              image: data["image"] ?? '',
              description: data["description"] ?? '',
            );
          }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add new product
  Future<void> addProduct(Product product) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("products")
          .add(product.toMap());
      // Add the new product to the local list
      _products.add(
        Product(
          id: docRef.id,
          name: product.name,
          price: product.price,
          description: product.description,
          image: product.image,
          isAvailable: product.isAvailable,
        ),
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(product.id)
          .update(product.toMap());

      // Update the product in the local list
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .delete();

      // Remove the product from the local list
      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Toggle product availability
  Future<void> toggleProductAvailability(
    String productId,
    bool isAvailable,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .update({'isAvailable': isAvailable});

      // Update the product in the local list
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = Product(
          id: _products[index].id,
          name: _products[index].name,
          price: _products[index].price,
          description: _products[index].description,
          image: _products[index].image,
          isAvailable: isAvailable,
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Add feature product
  Future<void> addFeatureProduct(Product product) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("products")
          .doc("qtZQegLgnUOMbI9WRusO")
          .collection("featureproduct")
          .add(product.toMap());

      _featureProducts.add(
        Product(
          id: docRef.id,
          name: product.name,
          price: product.price,
          image: product.image,
        ),
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Add new achieve product
  Future<void> addNewAchieveProduct(Product product) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("products")
          .doc("qtZQegLgnUOMbI9WRusO")
          .collection("newachives")
          .add(product.toMap());

      _newAchieveProducts.add(
        Product(
          id: docRef.id,
          name: product.name,
          price: product.price,
          image: product.image,
        ),
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Delete feature product
  Future<void> deleteFeatureProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc("qtZQegLgnUOMbI9WRusO")
          .collection("featureproduct")
          .doc(productId)
          .delete();

      _featureProducts.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Delete new achieve product
  Future<void> deleteNewAchieveProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc("qtZQegLgnUOMbI9WRusO")
          .collection("newachives")
          .doc(productId)
          .delete();

      _newAchieveProducts.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Thêm phương thức edit cho feature product
  Future<void> editFeatureProduct(Product product) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc("qtZQegLgnUOMbI9WRusO")
          .collection("featureproduct")
          .doc(product.id)
          .update(product.toMap());

      final index = _featureProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _featureProducts[index] = product;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Thêm phương thức edit cho new achieve product
  Future<void> editNewAchieveProduct(Product product) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc("qtZQegLgnUOMbI9WRusO")
          .collection("newachives")
          .doc(product.id)
          .update(product.toMap());

      final index = _newAchieveProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _newAchieveProducts[index] = product;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
