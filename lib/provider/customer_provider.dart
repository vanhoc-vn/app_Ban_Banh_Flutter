import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get customers => _customers;
  bool get isLoading => _isLoading;

  // Lấy dữ liệu từ bảng 'users' trên Firebase
  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Lấy toàn bộ document trong collection 'users'
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      // Debug: In ra số lượng document tìm thấy
      debugPrint("Tìm thấy ${snapshot.docs.length} khách hàng trong Firestore");

      _customers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'uid': doc.id,
          'email': data['email'] ?? 'Chưa có email',
          'userName': data['userName'] ?? 'Khách hàng ẩn danh', // Hiển thị userName
          'phone': data['phone'] ?? 'Chưa có SĐT',
          'isBlocked': data['isBlocked'] ?? false,
          'role': data['role'] ?? 'user', // Lấy thêm role để phân loại
        };
      }).toList();
    } catch (e) {
      debugPrint("Lỗi fetchCustomers: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Chặn hoặc bỏ chặn người dùng
  Future<void> toggleBlockUser(String uid, bool isBlocked) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isBlocked': !isBlocked,
      });

      // Cập nhật trạng thái ngay lập tức trong danh sách cục bộ
      final index = _customers.indexWhere((customer) => customer['uid'] == uid);
      if (index != -1) {
        _customers[index]['isBlocked'] = !isBlocked;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Lỗi toggleBlockUser: $e");
    }
  }
}