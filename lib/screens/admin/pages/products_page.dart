import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/admin_product_provider.dart';
import '../../../model/product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  // Màu sắc chủ đề Dream Cake
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late TabController _tabController;
  Product? _editingProduct;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      final provider = Provider.of<AdminProductProvider>(context, listen: false);
      provider.fetchFeatureProducts();
      provider.fetchNewAchieveProducts();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _editingProduct = null;
  }

  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quản lý sản phẩm',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showProductDialog(isFeature: _tabController.index == 0),
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm bánh mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 5,
                    shadowColor: _primary.withOpacity(0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              labelColor: _primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Sản phẩm nổi bật'),
                Tab(text: 'Sản phẩm mới'),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProductList(isFeature: true),
                  _buildProductList(isFeature: false)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList({required bool isFeature}) {
    return Consumer<AdminProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: _primary));
        }

        final products = isFeature ? provider.featureProducts : provider.newAchieveProducts;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cake_outlined, size: 80, color: _primary.withOpacity(0.2)),
                const SizedBox(height: 16),
                Text(
                  'Chưa có bánh ${isFeature ? "nổi bật" : "mới"} nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    product.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 70, color: Colors.grey),
                  ),
                ),
                title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(formatPrice(product.price),
                      style: const TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                      onPressed: () => _showProductDialog(isFeature: isFeature, product: product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _showDeleteConfirmation(product, isFeature),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showProductDialog({required bool isFeature, Product? product}) {
    if (product != null) {
      _editingProduct = product;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _descriptionController.text = product.description ?? '';
      _imageUrlController.text = product.image;
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          product == null ? 'Thêm bánh ${isFeature ? "nổi bật" : "mới"}' : 'Sửa thông tin bánh',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, 'Tên bánh', Icons.cake_outlined),
                const SizedBox(height: 15),
                _buildTextField(_priceController, 'Giá bán (\$)', Icons.attach_money, isNumber: true),
                const SizedBox(height: 15),
                _buildTextField(_descriptionController, 'Mô tả chi tiết', Icons.description_outlined, maxLines: 3),
                const SizedBox(height: 15),
                _buildTextField(_imageUrlController, 'Link hình ảnh (URL)', Icons.link),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            onPressed: () => _saveProduct(isFeature),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(product == null ? 'Thêm mới' : 'Lưu cập nhật'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: _primary),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: _primary)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Vui lòng không để trống' : null,
    );
  }

  Future<void> _saveProduct(bool isFeature) async {
    if (!_formKey.currentState!.validate()) return;

    final productData = Product(
      id: _editingProduct?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      image: _imageUrlController.text,
    );

    try {
      final provider = Provider.of<AdminProductProvider>(context, listen: false);
      if (_editingProduct == null) {
        isFeature ? await provider.addFeatureProduct(productData) : await provider.addNewAchieveProduct(productData);
      } else {
        isFeature ? await provider.editFeatureProduct(productData) : await provider.editNewAchieveProduct(productData);
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu thành công!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating)
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating)
      );
    }
  }

  void _showDeleteConfirmation(Product product, bool isFeature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa bánh "${product.name}" khỏi danh sách?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<AdminProductProvider>(context, listen: false);
              isFeature ? provider.deleteFeatureProduct(product.id!) : provider.deleteNewAchieveProduct(product.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }
}