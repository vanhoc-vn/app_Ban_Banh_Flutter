import 'package:e_commerical/screens/cartscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final double price;
  final String description;

  const DetailScreen({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const Color _primary = Color(0xFFF23B7E); // Màu hồng thương hiệu
  static const Color _bg = Color(0xFFFFF6FB);    // Nền hồng nhạt

  int count = 1;
  String selectedSize = "M"; // Mặc định chọn size M

  // --- Widget: Hình ảnh sản phẩm với hiệu ứng Hero ---
  Widget _buildProductImage() {
    return Stack(
      children: [
        Hero(
          tag: widget.image, // Đảm bảo tag này khớp với SingleProduct bên HomePage
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.cover),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
        ),
        // Nút Back tùy chỉnh
        Positioned(
          top: 40,
          left: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget: Thông tin cơ bản (Tên & Giá) ---
  Widget _buildHeaderInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: _primary.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
          child: Text(
            "\$${widget.price.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primary),
          ),
        ),
      ],
    );
  }

  // --- Widget: Chọn kích cỡ ---
  Widget _buildSizeOption(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 55,
        height: 45,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? _primary : Colors.grey.shade300),
          boxShadow: isSelected ? [BoxShadow(color: _primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          size,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- Widget: Tăng giảm số lượng ---
  Widget _buildQuantityControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyBtn(Icons.remove, () { if (count > 1) setState(() => count--); }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(count.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _buildQtyBtn(Icons.add, () => setState(() => count++)),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: _primary, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 20),

                  const Text("Mô tả sản phẩm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
                  ),

                  const SizedBox(height: 25),
                  const Text("Kích cỡ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: ["S", "M", "L", "XL"].map((s) => _buildSizeOption(s)).toList()),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Số lượng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _buildQuantityControl(),
                    ],
                  ),

                  const SizedBox(height: 40),
                  // Nút đặt hàng nổi bật
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        shadowColor: _primary.withOpacity(0.5),
                      ),
                      onPressed: () {
                        productProvider.getCartData(
                          image: widget.image,
                          name: widget.name,
                          price: widget.price,
                          quantity: count,
                        );
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => CartScreen()));
                      },
                      child: const Text(
                        "THÊM VÀO GIỎ HÀNG",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}