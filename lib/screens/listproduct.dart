import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
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
  // const ListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
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
      body: Column(
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
        ],
      ),
    );
  }
}
//4:36
