import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'user')
              .get();

      _customers =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'uid': doc.id,
              'email': data['email'] ?? '',
              'userName': data['userName'] ?? '',
              'phone': data['phone'] ?? '',
              'isBlocked': data['isBlocked'] ?? false,
            };
          }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleBlockUser(String uid, bool isBlocked) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isBlocked': !isBlocked,
      });

      final index = _customers.indexWhere((customer) => customer['uid'] == uid);
      if (index != -1) {
        _customers[index]['isBlocked'] = !isBlocked;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
