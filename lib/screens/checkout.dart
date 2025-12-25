import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/cartsingleproduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // THÊM ĐỂ LẤY UID THẬT
import '../model/cartmodel.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  // Màu sắc đồng bộ Dream Cake
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  final TextStyle myStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  bool _isOrdering = false;

  // HÀM QUAN TRỌNG: Lưu đơn hàng với UID người dùng thật
  Future<void> _addOrder(BuildContext context, List<CartModel> cartList, double finalTotal) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isOrdering = true);
      try {
        // Lấy thông tin người dùng đang đăng nhập
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw "Bạn cần đăng nhập để đặt hàng";

        String address = _addressController.text.trim();
        CollectionReference orders = FirebaseFirestore.instance.collection('orders');
        DocumentReference orderRef = orders.doc();

        // Cấu trúc dữ liệu đơn hàng khớp với OrderProvider
        Map<String, dynamic> orderData = {
          'orderId': orderRef.id,
          'userId': user.uid, // ĐÃ SỬA: Lấy UID từ Firebase Auth thay vì 'user123'
          'products': cartList.map((item) => {
            'name': item.name,
            'quantity': item.quantity,
            'price': item.price,
          }).toList(),
          'totalAmount': finalTotal,
          'status': 'pending', // Trạng thái mặc định
          'shippingAddress': {
            'street': address,
          },
          'orderDate': FieldValue.serverTimestamp(),
        };

        await orderRef.set(orderData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đặt hàng thành công!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Xóa giỏ hàng sau khi đặt thành công
          Provider.of<ProductProvider>(context, listen: false).clearCart();
          _addressController.clear();
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isOrdering = false);
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartList = productProvider.getCartModelList;

    // Tính toán tiền bạc
    double totalPrice = cartList.fold(0.0, (sum, item) => sum + (item.price ?? 0.0) * (item.quantity ?? 0));
    double discount = totalPrice * 0.03;
    double shippingCost = 2.0; // Phí ship tính theo $ cho đồng bộ
    double finalTotal = totalPrice - discount + shippingCost;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Thanh toán", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, cartList, finalTotal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ô nhập địa chỉ bo tròn hiện đại
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                ),
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ nhận bánh',
                    prefixIcon: Icon(Icons.location_on, color: _primary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
                ),
              ),
              const SizedBox(height: 25),

              const Text("Tóm tắt đơn hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Danh sách sản phẩm
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartList.length,
                itemBuilder: (ctx, index) {
                  final item = cartList[index];
                  return CartSingleProduct(
                    quantity: item.quantity ?? 0,
                    image: item.image ?? '',
                    name: item.name ?? '',
                    price: item.price ?? 0.0,
                    onQuantityChanged: (newQty) => productProvider.updateQuantity(item.name!, newQty),
                  );
                },
              ),

              const SizedBox(height: 20),
              _buildPriceSummary(totalPrice, discount, shippingCost, finalTotal),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary(double total, double disc, double ship, double finalT) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _summaryRow("Tạm tính", "\$${total.toStringAsFixed(2)}"),
          _summaryRow("Giảm giá (3%)", "-\$${disc.toStringAsFixed(2)}"),
          _summaryRow("Phí vận chuyển", "\$${ship.toStringAsFixed(2)}"),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tổng thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("\$${finalT.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, List<CartModel> list, double total) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        onPressed: _isOrdering ? null : () => _addOrder(context, list, total),
        child: _isOrdering
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("XÁC NHẬN ĐẶT BÁNH", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}