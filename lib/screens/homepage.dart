import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerical/provider/categorie_provider.dart';
import 'package:e_commerical/screens/detailscreen.dart';
import 'package:e_commerical/screens/listproduct.dart';
import 'package:e_commerical/widgets/singleproduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CategoryProvider provider;
  bool homeColor = true;
  bool cartColor = false;
  bool aboutColor = false;
  bool contactUsColor = false;

  Product? menData;
  Product? womenData;
  Product? buibData;
  Product? smartPhoneData;

  QuerySnapshot? shirtSnapShot;
  QuerySnapshot? featureSnapShot;
  QuerySnapshot? newAchivesSnapShot;

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
      provider = Provider.of<CategoryProvider>(context, listen: false);
      provider.getShirtData();
      provider.getDressData();
      provider.getShoesData();
      provider.getPantData();
      provider.getTieData();
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
          child: Image(color: Colors.white, image: AssetImage("images/$image")),
        ),
      ),
    );
  }

  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Tiệm bánh Học Đức", style: TextStyle(color: Colors.black)),
            currentAccountPicture: CircleAvatar(backgroundImage: AssetImage("images/hinhbongnoluc.jpg")),
            decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            accountEmail: Text("hoclv.04@gmail.com", style: TextStyle(color: Colors.black)),
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
            onTap: () {},
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
              Text("Categorie", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _categoryItem("Dress", dress),
              _categoryItem("Shirt", shirts),
              _categoryItem("Shoes", shoes),
              _categoryItem("Pant", pant),
              _categoryItem("Tie", tie),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(String name, List<Product> data) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ListProduct(name: name, snapShot: data),
        ));
      },
      child: _buildCategoryProduct(image: "icon_ao.png", color: 0xff33dcfd),
    );
  }

  Widget _buildNewAchives() {
    if (buibData == null || smartPhoneData == null) return SizedBox.shrink();

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
                  Text("New Achives", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).pushReplacement(
                  //       MaterialPageRoute(
                  //         builder: (ctx) => ListProduct(name: "New Achives", snapShot: newAchivesSnapShot),
                  //       ),
                  //     );
                  //   },
                  //   child: Text("View more", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _productItem(buibData!),
              _productItem(smartPhoneData!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatured() {
    if (menData == null || womenData == null) return SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Featured", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //         builder: (ctx) => ListProduct(name: "Featured", snapShot: featureSnapShot),
            //       ),
            //     );
            //   },
            //   child: Text("View more", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // ),
          ],
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _productItem(menData!),
              _productItem(womenData!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _productItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
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
          IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("category")
            .doc("ZITKuL6SpEr9vvWPijS7")
            .collection("shirt")
            .get(),
        builder: (context, shirtSnap) {
          if (shirtSnap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          shirtSnapShot = shirtSnap.data;

          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("products")
                .doc("qtZQegLgnUOMbI9WRusO")
                .collection("featureproduct")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text("Đã xảy ra lỗi khi tải dữ liệu"));

              final docs = snapshot.data!.docs;
              if (docs.length < 2) return Center(child: Text("Không đủ dữ liệu để hiển thị Featured"));

              featureSnapShot = snapshot.data;
              menData = Product(
                image: docs[0]["image"],
                name: docs[0]["name"],
                price: docs[0]["price"].toDouble(),
              );
              womenData = Product(
                image: docs[1]["image"],
                name: docs[1]["name"],
                price: docs[1]["price"].toDouble(),
              );

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("products")
                    .doc("qtZQegLgnUOMbI9WRusO")
                    .collection("newachives")
                    .get(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapShot.hasError) return Center(child: Text("Đã xảy ra lỗi khi tải dữ liệu"));

                  final docs = snapShot.data!.docs;
                  if (docs.length < 3) return Center(child: Text("Không đủ dữ liệu để hiển thị New Achives"));

                  newAchivesSnapShot = snapShot.data;
                  buibData = Product(
                    image: docs[0]["image"],
                    name: docs[0]["name"],
                    price: docs[0]["price"].toDouble(),
                  );
                  smartPhoneData = Product(
                    image: docs[2]["image"],
                    name: docs[2]["name"],
                    price: docs[2]["price"].toDouble(),
                  );

                  return Container(
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
