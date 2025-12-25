import 'package:flutter/material.dart';

class CartSingleProduct extends StatelessWidget {
  final String name;
  final String image;
  final int quantity; // Chuyển sang final
  final double price;
  final bool isCount;
  final void Function(int) onQuantityChanged;

  const CartSingleProduct({
    super.key,
    required this.quantity,
    required this.image,
    required this.name,
    required this.price,
    this.isCount = true,
    required this.onQuantityChanged,
  });

  static const Color _primary = Color(0xFFF23B7E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hình ảnh sản phẩm (Bo góc)
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
          ),

          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  "Dream Cake Bakery",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Bộ điều khiển số lượng (Thiết kế hiện đại)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                _buildQtyIcon(Icons.add, () => onQuantityChanged(quantity + 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildQtyIcon(
                    Icons.remove,
                        () => onQuantityChanged(quantity > 1 ? quantity - 1 : 0)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget con cho nút bấm cộng/trừ
  Widget _buildQtyIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: _primary),
      ),
    );
  }
}