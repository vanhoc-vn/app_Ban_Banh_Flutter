import 'package:e_commerical/model/product.dart';
import 'package:e_commerical/screens/detailscreen.dart'; // Import DetailScreen
import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
  final String name;
  final List<Product> snapShot;

  ListProduct({required this.name, required this.snapShot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
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
                              fontWeight: FontWeight.bold,
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
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    scrollDirection: Axis.vertical,
                    children: snapShot.map((product) { // Iterate through snapShot
                      return _buildProductItem(product, context); // Build item
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // New function to build each product item
  Widget _buildProductItem(Product product, BuildContext context) {
    return GestureDetector( // Wrap with GestureDetector
      onTap: () {
        Navigator.of(context).push( // Navigate to DetailScreen on tap
          MaterialPageRoute(
            builder: (ctx) => DetailScreen( // Pass product details
              image: product.image,
              name: product.name,
              price: product.price,
            ),
          ),
        );
      },
      child: Card( // Use a Card for better UI
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded( // Use Expanded to take up available space
                child: Center(
                  child: Image.network( // Use Image.network
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                "\$${product.price.toStringAsFixed(2)}", // Format price
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

