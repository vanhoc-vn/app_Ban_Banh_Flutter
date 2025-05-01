import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  Widget _buildFeaturedProduct({
    required String name,
    required double price,
    required String image,
  }) {
    return Card(
      child: Container(
        height: 250,
        width: 160,
        child: Column(
          children: <Widget>[
            Container(
              height: 190,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/$image")),
              ),
            ),
            Text(
              "\$ $price",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xff9b96d6),
              ),
            ),
            Text(name, style: TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProduct({required String image, required int color}) {
    return CircleAvatar(
      maxRadius: 30,
      backgroundColor: Color(color),
      child: Container(
        height: 40,
        child: Image(color: Colors.white, image: AssetImage("images/$image")),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  // const HomePage({super.key});
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
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
      //  color: Colors.white,
        height: double.infinity,
        // chiều cao bao phủ hết cái body
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Container(
                  height: 120,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search Something",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Featured",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold, // chu dam
                                  ),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold, // chu dam
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _buildFeaturedProduct(
                              name: "Bánh mỳ Sài Gòn",
                              price: 30.0,
                              image: "banhmy01.png",
                            ),
                            _buildFeaturedProduct(
                              name: "Hình ảnh nỗ lực",
                              price: 33.0,
                              image: "hinhbongnoluc.jpg",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Categorie",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
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
                              fontWeight: FontWeight.bold, // chu dam
                            ),
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold, // chu dam
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _buildFeaturedProduct(
                              name: "A man Watch",
                              price: 30.0,
                              image: "banhmy01.png",
                            ),
                            _buildFeaturedProduct(
                              name: "A men pant",
                              price: 33.0,
                              image: "hinhbongnoluc.jpg",),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//39:28
