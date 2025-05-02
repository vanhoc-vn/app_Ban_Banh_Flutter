import 'package:e_commerical/screens/homepage.dart';
import 'package:e_commerical/widgets/singleproduct.dart';
import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
  final String name;

  ListProduct({required this.name});

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

  // const ListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => HomePage()),
            );
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
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
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
                SizedBox(height: 10),
                Container(
                  height: 700,
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.6,
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      SingleProduct(
                        name: "Bánh mỳ Sài Gòn",
                        price: 30.0,
                        image: "banhmy01.png",
                      ),
                      SingleProduct(
                        name: "Hình ảnh nỗ lực",
                        price: 33.0,
                        image: "hinhbongnoluc.jpg",
                      ),
                      SingleProduct(
                        name: "Mobile Cover",
                        price: 30.0,
                        image: "banhmy01.png",
                      ),
                      SingleProduct(
                        name: "Google Mp3",
                        price: 33.0,
                        image: "hinhbongnoluc.jpg",
                      ),
                      SingleProduct(
                        name: "Camera",
                        price: 30.0,
                        image: "banhmy01.png",
                      ),
                      SingleProduct(
                        name: "Mouse",
                        price: 33.0,
                        image: "hinhbongnoluc.jpg",
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

//4:36
