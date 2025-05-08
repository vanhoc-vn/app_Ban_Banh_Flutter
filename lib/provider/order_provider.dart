import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      _orders =
          snapshot.docs.map((doc) {
            return OrderModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
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

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': newStatus},
      );

      final index = _orders.indexWhere((order) => order.orderId == orderId);
      if (index != -1) {
        _orders[index] = OrderModel(
          orderId: _orders[index].orderId,
          products: _orders[index].products,
          shippingAddress: _orders[index].shippingAddress,
          status: newStatus,
          totalAmount: _orders[index].totalAmount,
          userId: _orders[index].userId,
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
