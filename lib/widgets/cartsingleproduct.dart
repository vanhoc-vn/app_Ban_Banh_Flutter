import 'package:flutter/material.dart';

class CartSingleProduct extends StatefulWidget {
  final String name;
  final String image;
  int quentity;
  final double price;
  final bool isCount;

  CartSingleProduct({
    required this.quentity,
    required this.image,
    required this.name,
    required this.price,
    this.isCount = true,
  });

  @override
  State<CartSingleProduct> createState() => _CartSingleProductState();
}

TextStyle myStyle = TextStyle(fontSize: 18);

class _CartSingleProductState extends State<CartSingleProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  height: 110,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.image),
                    ),
                  ),
                ),
                Container(
                  height: 140,
                  width: 200,
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.name),
                        Text("Cloths"),
                        Text(
                          "\$${widget.price.toString()}",
                          style: TextStyle(
                            color: Color(0xff9b96d6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 35,
                          width: widget.isCount == false ? 120 : 100,
                          color: Color(0xfff2f2f2),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly, // Added spaceEvenly
                            children: <Widget>[
                              GestureDetector(
                                child: Icon(Icons.remove),
                                onTap: () {
                                  setState(() {
                                    if (widget.quentity > 1) {
                                      widget.quentity--;
                                    }
                                  });
                                },
                              ),
                              Text(
                                widget.quentity.toString(), // Use widget.quentity here
                                style: TextStyle(fontSize: 18),
                              ),
                              GestureDetector(
                                child: Icon(Icons.add),
                                onTap: () {
                                  setState(() {
                                    widget.quentity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

