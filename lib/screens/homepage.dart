import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerical/screens/detailscreen.dart';
import 'package:e_commerical/screens/listproduct.dart';
import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/widgets/singleproduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../provider/categorie_provider.dart';
import '../provider/product_provider.dart';
import '../screens/cartscreen.dart'; // Import CartScreen

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CategoryProvider categoryProvider;
  late ProductProvider productProvider;

  bool homeColor = true;
  bool cartColor = false;
  bool aboutColor = false;
  bool contactUsColor = false;
  bool _isSearching = false; // Add search state variable
  TextEditingController _searchController =
      TextEditingController(); // Add text editing controller

  List<Product> shirts = [];
  List<Product> dress = [];
  List<Product> shoes = [];
  List<Product> pant = [];
  List<Product> tie = [];
  List<Product> _searchResult =
      []; // List to store search results, initially empty

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.getShirtData();
    categoryProvider.getDressData();
    categoryProvider.getShoesData();
    categoryProvider.getPantData();
    categoryProvider.getTieData();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.getNewAchiveData();
    productProvider.getFutureData();
    productProvider.getHomeFeatureData();
    productProvider.getHomeAchiveData();
    super.initState();
  }

  Widget _buildCategoryProduct({required String image, required int color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Color(color),
        child: Container(
          height: 40,
          child: Image(
            color: Colors.white,
            image: NetworkImage(image),
          ), // Use NetworkImage
        ),
      ),
    );
  }

  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "Dream cake",
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("images/hinhbongnoluc.jpg"),
            ),
            decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            accountEmail: Text(
              "hoclv.04@gmail.com",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                contactUsColor = false;
                cartColor = false;
                aboutColor = false;
              });
            },
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
          ListTile(
            selected: cartColor,
            onTap: () {
              setState(() {
                cartColor = true;
                contactUsColor = false;
                homeColor = false;
                aboutColor = false;
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(), // Navigate to CartScreen
                ),
              );
            },
            leading: Icon(Icons.shopping_cart),
            title: Text("Cart"),
          ),
          ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                aboutColor = true;
                contactUsColor = false;
                homeColor = false;
                cartColor = false;
              });
            },
            leading: Icon(Icons.info),
            title: Text("About"),
          ),
          ListTile(
            selected: contactUsColor,
            onTap: () {
              setState(() {
                contactUsColor = true;
                cartColor = false;
                homeColor = false;
                aboutColor = false;
              });
            },
            leading: Icon(Icons.phone),
            title: Text("Contact Us"),
          ),
          ListTile(
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng xuất thành công!")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } catch (e) {
                print("Lỗi đăng xuất: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Đã xảy ra lỗi khi đăng xuất.")),
                );
              }
            },
            leading: Icon(Icons.logout),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      height: 180,
      width: double.infinity,
      child: FlutterCarousel(
        items: [
          Image.asset(
            "images/thu01.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ), // Thêm fit: BoxFit.fill
          Image.asset(
            "images/banhmy01.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Image.asset(
            "images/thu2.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ), //// Thêm fit: BoxFit.fill
        ],
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 250,
        ),
      ),
    );
  }

  Widget _buildCategory() {
    final provider = Provider.of<CategoryProvider>(context);
    shirts = provider.getShirtList;
    dress = provider.getDressList;
    shoes = provider.getshoesList;
    pant = provider.getPantList;
    tie = provider.getTieList;

    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Categorie",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _categoryItem(
                "Nước uống",
                dress,
                0xffFF6B81,
                "https://cdn-icons-png.flaticon.com/512/1824/1824898.png",
              ),
              _categoryItem(
                "bánh trung thu",
                shirts,
                0xff468499,
                "https://cdn-icons-png.flaticon.com/512/1284/1284358.png",
              ),
              _categoryItem(
                "Bánh mì các nước",
                shoes,
                0xff43AA8B,
                "https://cdn-icons-png.flaticon.com/512/2567/2567972.png",
              ),
              _categoryItem(
                "Mỳ gối",
                pant,
                0xffFFA726,
                "https://cdn-icons-png.flaticon.com/512/1151/1151516.png",
              ),
              _categoryItem(
                "Bánh sinh nhật",
                tie,
                0xff9C27B0,
                "https://cdn-icons-png.flaticon.com/512/1013/1013346.png",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(
    String name,
    List<Product> data,
    int color,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ListProduct(name: name, snapShot: data),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: CircleAvatar(
          maxRadius: 30,
          backgroundColor: Color(color),
          child: Container(
            height: 40,
            child: Image(color: Colors.white, image: NetworkImage(imagePath)),
          ),
        ),
      ),
    );
  }

  Widget _buildNewAchives() {
    // Sử dụng dữ liệu từ ProductProvider
    List<Product> newAchivesProduct = productProvider.getNewAchiesList;

    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "New Achives",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (ctx) => ListProduct(
                                name: "New Achieves",
                                snapShot: newAchivesProduct,
                              ),
                        ),
                      );
                    },
                    child: Text(
                      "View more",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        // Sử dụng SingleChildScrollView để tạo khả năng cuộn ngang
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                newAchivesProduct
                    .map((product) => _buildProductItem(product))
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatured() {
    // Lấy danh sách sản phẩm nổi bật từ ProductProvider.
    final List<Product> homeFeatureProduct =
        Provider.of<ProductProvider>(context, listen: false).getHomeFutureList;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                // Chuyển đến trang danh sách sản phẩm, hiển thị tất cả sản phẩm nổi bật.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (ctx) => ListProduct(
                          name: "Featured",
                          snapShot:
                              homeFeatureProduct, // Truyền danh sách sản phẩm nổi bật.
                        ),
                  ),
                );
              },
              child: Text(
                "View more",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Sử dụng SingleChildScrollView để tạo khả năng cuộn ngang
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                homeFeatureProduct
                    .map((product) => _buildProductItem(product))
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (ctx) => DetailScreen(
                  image: product.image,
                  name: product.name,
                  price: product.price,
                ),
          ),
        );
      },
      child: SingleProduct(
        image: product.image,
        name: product.name,
        price: product.price,
      ),
    );
  }

  // Function to perform product search
  void _searchProducts(String query) {
    List<Product> results = [];
    if (query.isNotEmpty) {
      // Search in all product lists
      results.addAll(
        shirts.where((p) => p.name.toLowerCase().contains(query.toLowerCase())),
      );
      results.addAll(
        dress.where((p) => p.name.toLowerCase().contains(query.toLowerCase())),
      );
      results.addAll(
        shoes.where((p) => p.name.toLowerCase().contains(query.toLowerCase())),
      );
      results.addAll(
        pant.where((p) => p.name.toLowerCase().contains(query.toLowerCase())),
      );
      results.addAll(
        tie.where((p) => p.name.toLowerCase().contains(query.toLowerCase())),
      );
      results.addAll(
        productProvider.getNewAchiesList.where(
          (p) => p.name.toLowerCase().contains(query.toLowerCase()),
        ),
      );
      results.addAll(
        productProvider.getHomeFutureList.where(
          (p) => p.name.toLowerCase().contains(query.toLowerCase()),
        ),
      );
      results.addAll(
        productProvider.getHomeAchiveList.where(
          (p) => p.name.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
    setState(() {
      _searchResult =
          results; // Update the search result list to trigger UI update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  // Show TextField in AppBar when searching
                  controller: _searchController,
                  onChanged:
                      _searchProducts, // Call _searchProducts on text change
                  autofocus: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm sản phẩm...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                )
                : Text(
                  "HomePage",
                  style: TextStyle(color: Colors.black),
                ), // Show "HomePage" title when not searching
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _key.currentState?.openDrawer(),
        ),
        actions: [
          // Change icon based on search state
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching =
                    !_isSearching; // Toggle search state on button press
                if (!_isSearching) {
                  // Clear search query and results when closing search
                  _searchController.clear();
                  _searchResult.clear();
                }
              });
            },
          ),
          // Remove the notifications icon
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child:
            _isSearching
                ? _buildSearchResult() // Show search results if searching
                : ListView(
                  // Otherwise show the main page content
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    _buildImageSlider(),
                    _buildCategory(),
                    SizedBox(height: 20),
                    _buildFeatured(),
                    _buildNewAchives(),
                  ],
                ),
      ),
    );
  }

  // Widget to display search results
  Widget _buildSearchResult() {
    if (_searchResult.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isEmpty
              ? "Nhập tên sản phẩm để tìm kiếm"
              : "Không tìm thấy sản phẩm nào",
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        children:
            _searchResult.map((product) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => DetailScreen(
                            image: product.image,
                            name: product.name,
                            price: product.price,
                          ),
                    ),
                  );
                },
                child: SingleProduct(
                  image: product.image,
                  name: product.name,
                  price: product.price,
                ),
              );
            }).toList(),
      );
    }
  }
}
