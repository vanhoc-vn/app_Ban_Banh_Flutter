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

Product? menData;
Product? womenData;
Product? buibData;
Product? smartPhoneData;

var mySnapShot;
var featureSnapShot;
var newAchivesSnapShot;

var tie;
var shoes;
var pant;
var dress;
var shirt;

class _HomePageState extends State<HomePage> {
  late CategoryProvider provider;

  bool homeColor = true;
  bool cartColor = false;
  bool aboutColor = false;
  bool contactUsColor = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Gọi provider sau khi build lần đầu
    Future.delayed(Duration.zero, () {
      final tempProvider = Provider.of<CategoryProvider>(context, listen: false);
      tempProvider.getShirtData();
      tempProvider.getDressData();
      tempProvider.getShoesData();
      tempProvider.getPantData();
      tempProvider.getTieData();
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
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("images/hinhbongnoluc.jpg"),
            ),
            decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            accountEmail: Text("hoclv.04@gmail.com", style: TextStyle(color: Colors.black)),
          ),
          _buildDrawerItem("Home", Icons.home, homeColor, () {
            setState(() {
              homeColor = true;
              cartColor = aboutColor = contactUsColor = false;
            });
          }),
          _buildDrawerItem("Cart", Icons.shopping_cart, cartColor, () {
            setState(() {
              cartColor = true;
              homeColor = aboutColor = contactUsColor = false;
            });
          }),
          _buildDrawerItem("About", Icons.info, aboutColor, () {
            setState(() {
              aboutColor = true;
              homeColor = cartColor = contactUsColor = false;
            });
          }),
          _buildDrawerItem("Contact Us", Icons.phone, contactUsColor, () {
            setState(() {
              contactUsColor = true;
              homeColor = cartColor = aboutColor = false;
            });
          }),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.logout),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(String title, IconData icon, bool selected, VoidCallback onTap) {
    return ListTile(
      selected: selected,
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
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
    List<Product> shirts = provider.getShirtList;
    List<Product> dresses = provider.getDressList;
    List<Product> shoesList = provider.getshoesList;
    List<Product> pants = provider.getPantList;
    List<Product> ties = provider.getTieList;

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
              _buildCategoryItem("Dress", dresses),
              _buildCategoryItem("Shirt", shirts),
              _buildCategoryItem("Shoes", shoesList),
              _buildCategoryItem("Pant", pants),
              _buildCategoryItem("Tie", ties),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String name, List<Product> list) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ListProduct(name: name, snapShot: list),
        ));
      },
      child: _buildCategoryProduct(image: "icon_ao.png", color: 0xff33dcfd),
    );
  }

  Widget _buildProductSection(String title, dynamic snapshotData, List<Product> products, List<Product> Function()? fallbackData) {
    if (products.isEmpty && fallbackData != null) products = fallbackData();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ListProduct(name: title, snapShot: snapshotData),
                ));
              },
              child: Text("View more", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: products.map((product) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => DetailScreen(
                      image: product.image,
                      name: product.name,
                      price: product.price,
                    ),
                  ));
                },
                child: SingleProduct(
                  image: product.image,
                  name: product.name,
                  price: product.price,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: Text("HomePage", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _key.currentState?.openDrawer(),
        ),
        actions: <Widget>[
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
        builder: (context, shirtSnapShot) {
          if (shirtSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          shirt = shirtSnapShot;

          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("products")
                .doc("qtZQegLgnUOMbI9WRusO")
                .collection("featureproduct")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              final docs = snapshot.data!.docs;
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
              featureSnapShot = snapshot;

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("products")
                    .doc("qtZQegLgnUOMbI9WRusO")
                    .collection("newachives")
                    .get(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());

                  final docs = snapShot.data!.docs;
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
                  newAchivesSnapShot = snapShot;

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: <Widget>[
                        _buildImageSlider(),
                        _buildCategory(),
                        SizedBox(height: 20),
                        _buildProductSection("Featured", featureSnapShot, [menData!, womenData!], null),
                        _buildProductSection("New Achives", newAchivesSnapShot, [buibData!, smartPhoneData!], null),
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
