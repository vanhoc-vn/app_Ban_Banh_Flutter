import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerical/screens/detailscreen.dart';
import 'package:e_commerical/screens/listproduct.dart';
import 'package:e_commerical/widgets/singleproduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../provider/categorie_provider.dart';
import '../provider/product_provider.dart';

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

  List<Product> shirts = [];
  List<Product> dress = [];
  List<Product> shoes = [];
  List<Product> pant = [];
  List<Product> tie = [];

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
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
    });
  }

  Widget _buildCategoryProduct({required String image, required int color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Color(color),
        child: Container(
          height: 40,
          child: Image(color: Colors.white, image: NetworkImage(image)), // Sử dụng NetworkImage
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
                // Không cần Navigator.pushReplacement ở đây vì StreamBuilder trong main.dart sẽ xử lý việc chuyển hướng
                // (Tùy chọn) Thêm code để xóa các dữ liệu cục bộ của người dùng nếu cần
                // Ví dụ:
                // Provider.of<CartProvider>(context, listen: false).clearCart();
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.remove('userToken');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng xuất thành công!")),
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
          Image.asset("images/mikhongmau.png", fit: BoxFit.cover),
          Image.asset("images/banhmy01.png", fit: BoxFit.cover),
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
                  "https://cdn-icons-png.flaticon.com/512/1824/1824898.png"),
              _categoryItem(
                  "bánh trung thu",
                  shirts,
                  0xff468499,
                  "https://cdn-icons-png.flaticon.com/512/1284/1284358.png"),
              _categoryItem(
                  "Bánh mì các nước",
                  shoes,
                  0xff43AA8B,
                  "https://cdn-icons-png.flaticon.com/512/2567/2567972.png"),
              _categoryItem(
                  "Mỳ gối",
                  pant,
                  0xffFFA726,
                  "https://cdn-icons-png.flaticon.com/512/1151/1151516.png"),
              _categoryItem(
                  "Bánh sinh nhật",
                  tie,
                  0xff9C27B0,
                  "https://cdn-icons-png.flaticon.com/512/1013/1013346.png"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(
      String name, List<Product> data, int color, String imagePath) {
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
                          builder: (ctx) => ListProduct(
                            name: "New Achieves",
                            snapShot: newAchivesProduct,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "View more",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  )
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
            children: newAchivesProduct
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
                    builder: (ctx) => ListProduct(
                      name: "Featured",
                      snapShot: homeFeatureProduct, // Truyền danh sách sản phẩm nổi bật.
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
            children: homeFeatureProduct
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
            builder: (ctx) => DetailScreen(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: Text("HomePage", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _key.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
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
}

