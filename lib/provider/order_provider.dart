import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // THÊM IMPORT NÀY
import 'package:flutter/material.dart';
import '../model/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];   // Dành cho Admin
  List<OrderModel> _myOrders = []; // Dành cho Người dùng (THÊM MỚI)
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  List<OrderModel> get myOrders => _myOrders; // GETTER MỚI
  bool get isLoading => _isLoading;

  // Lấy toàn bộ đơn hàng (Cho Admin)
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();
      _orders = snapshot.docs.map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      debugPrint("Lỗi fetchOrders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy đơn hàng của RIÊNG người dùng đang đăng nhập (SỬA LỖI TẠI ĐÂY)
  Future<void> fetchMyOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Lọc trên Firestore: Chỉ lấy đơn hàng có userId khớp với người đang dùng app
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      _myOrders = snapshot.docs.map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      debugPrint("Lỗi fetchMyOrders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({'status': newStatus});
      fetchOrders(); // Tải lại để cập nhật UI
      fetchMyOrders();
    } catch (e) {
      rethrow;
    }
  }
}