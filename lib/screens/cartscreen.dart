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
            // Sử dụng Navigator.push để chuyển đến màn hình CheckOutScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckOutScreen(), // Đã sửa tên class.
              ),
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
            // Sử dụng Navigator.of(context).pop() để quay lại trang trước
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
          quantity: productProvider.getCartModelList[index].quantity ?? 0,
          image: productProvider.getCartModelList[index].image ?? '',
          name: productProvider.getCartModelList[index].name ?? '',
          price: productProvider.getCartModelList[index].price ?? 0.0,
          onQuantityChanged: (newQuantity) {
            // Cập nhật số lượng trong product provider
            productProvider.updateQuantity(
              productProvider.getCartModelList[index].name!, // Pass the name of the item
              newQuantity,
            );
          },
        ),
      )
          : const Center(child: Text("Your cart is empty")),
    );
  }
}