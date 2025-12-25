import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerical/screens/detailscreen.dart';
import 'package:e_commerical/screens/listproduct.dart';
import 'package:e_commerical/screens/welcomescreen.dart';
import 'package:e_commerical/widgets/singleproduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../provider/categorie_provider.dart';
import '../provider/product_provider.dart';
import '../screens/cartscreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Đồng bộ màu sắc với màn hình Auth
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  List<Product> _searchResult = [];
  String? _userName;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu từ Firebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catProv = Provider.of<CategoryProvider>(context, listen: false);
      catProv.getShirtData();
      catProv.getDressData();
      catProv.getShoesData();
      catProv.getPantData();
      catProv.getTieData();

      final prodProv = Provider.of<ProductProvider>(context, listen: false);
      prodProv.getNewAchiveData();
      prodProv.getFutureData();
      prodProv.getHomeFeatureData();
    });
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          _userName = doc.data()?['userName'] ?? 'Khách';
          _loadingProfile = false;
        });
      }
    } catch (_) {
      setState(() => _loadingProfile = false);
    }
  }

  // --- Widget: Drawer Tùy Chỉnh ---
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _bg,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: _primary),
            accountName: Text(_loadingProfile ? "Đang tải..." : "Chào, $_userName",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('images/dream_cake_2.png', width: 50),
            ),
          ),
          _buildDrawerItem(Icons.home, "Trang chủ", () => Navigator.pop(context), true),
          _buildDrawerItem(Icons.shopping_cart, "Giỏ hàng", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
          }, false),
          _buildDrawerItem(Icons.info, "Về chúng tôi", () {}, false),
          const Spacer(),
          _buildDrawerItem(Icons.logout, "Đăng xuất", () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()), (route) => false);
          }, false, color: Colors.red),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, bool selected, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? (selected ? _primary : Colors.black54)),
      title: Text(title, style: TextStyle(color: color ?? (selected ? _primary : Colors.black87), fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      onTap: onTap,
    );
  }

  // --- Widget: Slider Quảng Cáo ---
  Widget _buildSlider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: _primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterCarousel(
          options: CarouselOptions(height: 180, autoPlay: true, viewportFraction: 1.0),
          items: ["images/thu01.png", "images/banhmy01.png", "images/thu2.png"].map((i) {
            return Image.asset(i, fit: BoxFit.cover, width: double.infinity);
          }).toList(),
        ),
      ),
    );
  }

  // --- Widget: Danh mục bánh (Đã sửa lỗi listen) ---
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text("Danh mục bánh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CategoryItem("Nước uống", 0xffFFEDF2, "https://cdn-icons-png.flaticon.com/512/3075/3075977.png"),
              _CategoryItem("Bánh Trung Thu", 0xffE8F5E9, "https://cdn-icons-png.flaticon.com/512/5900/5900629.png"),
              _CategoryItem("Bánh Mì", 0xffFFF3E0, "https://cdn-icons-png.flaticon.com/512/861/861124.png"),
              _CategoryItem("Mỳ Gối", 0xffE3F2FD, "https://cdn-icons-png.flaticon.com/512/5900/5900435.png"),
              _CategoryItem("Bánh Kem", 0xffF3E5F5, "https://cdn-icons-png.flaticon.com/512/5900/5900626.png"),
            ],
          ),
        ),
      ],
    );
  }

  // --- Widget: Header của Section ---
  Widget _buildSectionHeader(String title, List<Product> products) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListProduct(name: title, snapShot: products))),
            child: const Text("Tất cả", style: TextStyle(color: _primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: _bg,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu, color: _primary), onPressed: () => _key.currentState?.openDrawer()),
        title: _isSearching
            ? TextField(controller: _searchController, decoration: const InputDecoration(hintText: "Tìm bánh ngon...", border: InputBorder.none), autofocus: true)
            : Image.asset('images/dream_cake_2.png', height: 40),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: _primary),
            onPressed: () => setState(() => _isSearching = !_isSearching),
          ),
          IconButton(icon: const Icon(Icons.shopping_basket_outlined, color: _primary), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildSlider(),
            _buildCategorySection(),
            _buildSectionHeader("Sản phẩm nổi bật", productProvider.getHomeFutureList),
            _buildProductGrid(productProvider.getHomeFutureList),
            _buildSectionHeader("Sản phẩm mới", productProvider.getNewAchiesList),
            _buildProductGrid(productProvider.getNewAchiesList),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 15, mainAxisSpacing: 15),
      itemCount: products.length > 4 ? 4 : products.length,
      itemBuilder: (ctx, i) {
        final p = products[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(image: p.image, name: p.name, price: p.price, description: p.description ?? ""))),
          child: SingleProduct(image: p.image, name: p.name, price: p.price),
        );
      },
    );
  }
}

// --- Widget Danh Mục Item ---
class _CategoryItem extends StatelessWidget {
  final String name;
  final int bgColor;
  final String imagePath;

  _CategoryItem(this.name, this.bgColor, this.imagePath);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    List<Product> data;
    switch (name) {
      case "Nước uống": data = provider.getDressList; break;
      case "Bánh Trung Thu": data = provider.getShirtList; break;
      case "Bánh Mì": data = provider.getshoesList; break;
      case "Mỳ Gối": data = provider.getPantList; break;
      default: data = provider.getTieList;
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListProduct(name: name, snapShot: data))),
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(color: Color(bgColor), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
              child: Center(child: Image.network(imagePath, width: 35)),
            ),
            const SizedBox(height: 8),
            Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}