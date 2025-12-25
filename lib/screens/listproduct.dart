import 'package:e_commerical/model/product.dart';
import 'package:e_commerical/screens/detailscreen.dart';
import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
  final String name;
  final List<Product> snapShot;

  const ListProduct({super.key, required this.name, required this.snapShot});

  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Chức năng tìm kiếm trong danh mục (nếu cần)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: snapShot.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cake_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "Không có sản phẩm nào trong danh mục này",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
            : GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: snapShot.length,
          itemBuilder: (context, index) {
            final product = snapShot[index];
            return _buildProductItem(product, context);
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // CẬP NHẬT: Truyền thêm description sang DetailScreen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => DetailScreen(
              image: product.image,
              name: product.name,
              price: product.price,
              // Lấy mô tả từ Model (đã ánh xạ với product_details trên Firebase)
              description: product.description ?? "Chưa có mô tả cho sản phẩm này.",
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black87
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "\$ ${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 15,
                    color: _primary,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}