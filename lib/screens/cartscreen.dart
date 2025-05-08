import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/cartsingleproduct.dart';
import 'package:e_commerical/screens/checkout.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff746bc9)),
          child: Text(
            "Continue",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onPressed: () {
            // Use Navigator.push to go to the CheckOutScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckOutScreen()), // Corrected class name.
            );
          },
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cart Page", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Use Navigator.of(context).pop() to go back
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: productProvider.getCartModelList.isNotEmpty
          ? ListView.builder(
        itemCount: productProvider.getCartModelList.length,
        itemBuilder: (ctx, index) => CartSingleProduct(
          isCount: false,
          quentity: productProvider.getCartModelList[index].quentity ?? 0,
          image: productProvider.getCartModelList[index].image ?? '',
          name: productProvider.getCartModelList[index].name ?? '',
          price: productProvider.getCartModelList[index].price ?? 0.0,
        ),
      )
          : const Center(child: Text("Your cart is empty")),
    );
  }
}

