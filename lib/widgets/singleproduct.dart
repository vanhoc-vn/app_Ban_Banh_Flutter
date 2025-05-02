import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {

  final String image;
  final double price;
  final String name;

  const SingleProduct({
    required this.image,
    required this.name,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 250,
        width: 180,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Container(
                height: 190,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("images/$image"),
                  ),
                ),
              ),
            ),
            Text(
              "\$ ${price.toString()}",
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
}
