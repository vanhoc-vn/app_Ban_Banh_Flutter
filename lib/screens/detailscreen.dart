import 'package:e_commerical/screens/cartscreen.dart';
import 'package:e_commerical/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final double price;

  DetailScreen({required this.image, required this.name, required this.price});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int count = 1;
  late ProductProvider productProvider; // Late initialization

  Widget _buildSizeProduct({required String name}) {
    return Container(
      height: 60,
      width: 60,
      color: Color(0xfff2f2f2),
      child: Center(child: Text(name, style: TextStyle(fontSize: 17))),
    );
  }

  Widget _buildColorProduct({required Color color}) {
    return Container(height: 60, width: 60, color: color);
  }

  final TextStyle myStyle = TextStyle(fontSize: 18);

  Widget _buildImage() {
    return Center(
      child: Container(
        width: 350,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(13),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.image),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameToDescriptionPart() {
    return Container(
      height: 120,
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.name, style: TextStyle(fontSize: 18)),
              Text(
                "\$ ${widget.price.toString()}",
                style: TextStyle(color: Color(0xff9b96d6), fontSize: 18),
              ),
              Text("Description", style: myStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          "Bánh mì, một biểu tượng ẩm thực đường phố của Việt Nam, là sự kết hợp hài hòa giữa lớp vỏ bánh mì giòn tan và phần nhân phong phú, đậm đà. Từ những chiếc bánh mì đơn giản kẹp chả lụa, pate, đến những biến tấu đặc sắc như bánh mì thịt nướng, bánh mì xíu mại, bánh mì phá lấu, mỗi loại bánh mì mang một hương vị riêng, phản ánh sự đa dạng  .",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildSizePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDescription(),
        Text("Size", style: myStyle),
        SizedBox(height: 15),
        Container(
          width: 265,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildSizeProduct(name: "S"),
              _buildSizeProduct(name: "M"),
              _buildSizeProduct(name: "L"),
              _buildSizeProduct(name: "XXL"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Text("Color", style: TextStyle(fontSize: 18)),
        SizedBox(height: 15),
        Container(
          width: 265,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildColorProduct(color: Colors.blue),
              _buildColorProduct(color: Colors.green),
              _buildColorProduct(color: Colors.yellow),
              _buildColorProduct(color: Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPart() {
    return Container(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
        onPressed: () {
          productProvider.getCartData(
            image: widget.image,
            name: widget.name,
            price: widget.price,
            quantity: count,
          );
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => CartScreen()
            ,)
            ,);
        },
        child: Text('Check Out', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildQuentityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Text("Quentity", style: myStyle),
        SizedBox(height: 10),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.remove),
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
              ),
              Text(count.toString(), style: myStyle),
              GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context); // Initialize here
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail Page", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              _buildImage(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildNameToDescriptionPart(),
                    _buildSizePart(),
                    _buildColorPart(),
                    _buildQuentityPart(),
                    SizedBox(height: 15),
                    _buildButtonPart(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
