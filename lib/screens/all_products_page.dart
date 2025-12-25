import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/singleproduct.dart';
import 'detailscreen.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  @override
  void initState() {
    super.initState();
    // Đảm bảo Provider được khởi tạo và tải dữ liệu ngay khi vào trang
    Future.microtask(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.fetchAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text("Tất cả sản phẩm", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: _primary));
          }

          // Lấy danh sách gộp từ getter đã viết trong Provider
          final allProducts = provider.getAllProductsList;

          if (allProducts.isEmpty) {
            return const Center(child: Text("Hệ thống chưa có bánh nào"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(15),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: allProducts.length,
            itemBuilder: (ctx, i) {
              final p = allProducts[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      image: p.image,
                      name: p.name,
                      price: p.price,
                      // Lưu ý: Key trên Firestore là 'product_details'
                      description: p.description ?? "Bánh ngon từ Dream Cake.",
                    ),
                  ),
                ),
                child: SingleProduct(image: p.image, name: p.name, price: p.price),
              );
            },
          );
        },
      ),
    );
  }
}