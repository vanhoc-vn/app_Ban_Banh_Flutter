import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/cartsingleproduct.dart';
import 'package:e_commerical/screens/checkout.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color _primary = Color(0xFFF23B7E); // Hồng thương hiệu
  static const Color _bg = Color(0xFFFFF6FB);    // Nền hồng nhạt

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItems = productProvider.getCartModelList;

    // Tính tổng tiền trực tiếp trong build
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            "Giỏ hàng của bạn",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // Chỉ hiện thanh toán khi có hàng trong giỏ
      bottomNavigationBar: cartItems.isNotEmpty
          ? _buildBottomSummary(total)
          : null,
      body: cartItems.isNotEmpty
          ? ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: cartItems.length,
        itemBuilder: (ctx, index) {
          final item = cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CartSingleProduct(
              isCount: false,
              quantity: item.quantity,
              image: item.image,
              name: item.name,
              price: item.price,
              onQuantityChanged: (newQuantity) {
                productProvider.updateQuantity(item.name, newQuantity);
              },
            ),
          );
        },
      )
          : _buildEmptyCart(),
    );
  }

  // --- Widget: Giao diện khi giỏ hàng trống ---
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 100, color: _primary.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text(
            "Giỏ hàng của bạn đang trống",
            style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Mua bánh ngay", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  // --- Widget: Thanh tổng tiền và nút Tiếp tục ---
  Widget _buildBottomSummary(double total) {
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tổng cộng:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primary),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 5,
                shadowColor: _primary.withOpacity(0.4),
              ),
              child: const Text(
                "Tiếp tục thanh toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOutScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}