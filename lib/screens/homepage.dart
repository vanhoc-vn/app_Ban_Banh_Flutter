import 'package:e_commerical/screens/listproduct.dart';
import 'package:e_commerical/widgets/singleproduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomePage extends StatelessWidget {
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

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("HomePage", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _key.currentState?.openDrawer();
          },
        ),
        actions: <Widget>[
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
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 180,
                        width: double.infinity,
                        child: FlutterCarousel(
                          items: [
                            Image.asset(
                              "images/mikhongmau.png",
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              "images/banhmy01.png",
                              fit: BoxFit.cover,
                            ),
                          ],
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1.0,
                            height: 250,
                          ),
                        ),
                      ),

                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Categorie",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            _buildCategoryProduct(
                              image: "icon_ao.png",
                              color: 0xff33dcfd,
                            ),
                            _buildCategoryProduct(
                              image: "icon_ao.png",
                              color: 0xfff38cdd,
                            ),
                            _buildCategoryProduct(
                              image: "icon_ao.png",
                              color: 0xff4ff2af,
                            ),
                            _buildCategoryProduct(
                              image: "icon_ao.png",
                              color: 0xff74acf7,
                            ),
                            _buildCategoryProduct(
                              image: "icon_ao.png",
                              color: 0xfffc6c8d,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Featured",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (ctx) => ListProduct(name: "Featured"
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "View more",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              SingleProduct(
                                image: "banhmy01.png",
                                name: "Men Long T Shirt",
                                price: 30.0,
                              ),
                              SingleProduct(
                                image: "banhmy01.png",
                                name: "Women white watch",
                                price: 33.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder:
                                      (ctx) => ListProduct(name: "New Achives"
                                      ),
                                ),
                              );
                            },

                            child: Text(
                              "View more",
                              style: TextStyle(
                                fontSize: 16,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      SingleProduct(
                        image: "banhmy01.png",
                        name: "A Men Watch",
                        price: 30.0,
                      ),
                      SingleProduct(
                        image: "banhmy01.png",
                        name: "A Men Pant",
                        price: 33.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
