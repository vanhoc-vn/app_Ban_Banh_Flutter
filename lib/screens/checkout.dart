import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/cartsingleproduct.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final TextStyle myStyle = TextStyle(fontSize: 18);

  Widget _buildBottomDetail({
    required String startName,
    required String endName,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(startName, style: myStyle),
          Text(endName, style: myStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    double totalPrice = 0.0;
    for (var cartItem in productProvider.getCartModelList) {
      totalPrice += (cartItem.price ?? 0.0) * (cartItem.quantity ?? 0);
    }

    double discount = totalPrice * 0.03;
    double shippingCost = 60.00;
    double finalTotal = totalPrice - discount + shippingCost;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checkout Page", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff746bc9)),
          child: Text("Buy", style: TextStyle(fontSize: 18, color: Colors.white)),
          onPressed: () {
            // TODO: Add buy logic
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            productProvider.getCartModelList.isNotEmpty
                ? Expanded(
              // Use Expanded to allow the ListView.builder to take up available space
              child: ListView.builder(
                itemCount: productProvider.getCartModelList.length,
                itemBuilder: (ctx, index) {
                  final cartItem =
                  productProvider.getCartModelList[index];
                  return Column(
                    // Wrap CartSingleProduct and details in a Column
                    children: [
                      CartSingleProduct(
                        quantity: cartItem.quantity ?? 0,
                        image: cartItem.image ?? '',
                        name: cartItem.name ?? '',
                        price: cartItem.price ?? 0.0,
                        onQuantityChanged: (newQuantity) {
                          //  setState(() {});  // Không cần setState ở đây
                          //  Quan trọng: Cập nhật giá trị trong provider để bên này tự cập nhật theo
                          productProvider.updateQuantity(
                              cartItem.name!, newQuantity); // Pass the name and newQuantity

                          // Gọi lại setState để rebuild lại trang và hiển thị giá mới
                          setState(() {});
                        },
                      ),
                      _buildBottomDetail(
                        startName: "Your Price",
                        endName:
                        "\$${(cartItem.price ?? 0.0).toStringAsFixed(2)}",
                      ),
                      if (index ==
                          productProvider.getCartModelList.length - 1) ...[
                        _buildBottomDetail(
                          startName: "Discount",
                          endName: "-\$${discount.toStringAsFixed(2)}",
                        ),
                        _buildBottomDetail(
                          startName: "Shipping",
                          endName: "\$${shippingCost.toStringAsFixed(2)}",
                        ),
                        Divider(thickness: 1.2),
                        _buildBottomDetail(
                          startName: "Total",
                          endName: "\$${finalTotal.toStringAsFixed(2)}",
                        ),
                      ],
                    ],
                  );
                },
              ),
            )
                : const Center(
              child: Text("Your cart is empty",
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}