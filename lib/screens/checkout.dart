import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/cartsingleproduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cartmodel.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final TextStyle myStyle = TextStyle(fontSize: 18);
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  bool _isOrdering = false;
  bool _firebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    if (mounted) {
      setState(() {
        _firebaseInitialized = true;
      });
    }
  }

  Future<void> _addOrder(
      BuildContext context, List<CartModel> cartList, double finalTotal) async {
    if (!_firebaseInitialized) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isOrdering = true);
      try {
        String address = _addressController.text.trim();
        CollectionReference orders = FirebaseFirestore.instance.collection('orders');
        DocumentReference orderRef = orders.doc();
        String userId = 'user123'; // Replace with actual user ID

        Map<String, dynamic> orderData = {
          'orderId': orderRef.id,
          'userId': userId,
          'products': cartList.map((item) => {
            'productId': item.name,
            'name': item.name,
            'quantity': item.quantity,
            'price': item.price,
          }).toList(),
          'totalAmount': finalTotal,
          'status': 'pending', // Trạng thái đơn hàng
          'shippingAddress': {
            'street': address,
          },
          'orderDate': FieldValue.serverTimestamp(),
        };


        await orderRef.set(orderData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order placed successfully!')),
          );
          Provider.of<ProductProvider>(context, listen: false).clearCart();
          _addressController.clear();
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order: $error')),
          );
        }
      } finally {
        if (mounted) setState(() => _isOrdering = false);
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Widget _buildBottomDetail({required String startName, required String endName}) {
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
    final cartList = productProvider.getCartModelList;

    double totalPrice = cartList.fold(
        0.0, (sum, item) => sum + (item.price ?? 0.0) * (item.quantity ?? 0));
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
          onPressed: _isOrdering || !_firebaseInitialized
              ? null
              : () => _addOrder(context, cartList, finalTotal),
          child: _isOrdering
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : Text("Buy", style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Shipping Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter your shipping address' : null,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (ctx, index) {
                    final cartItem = cartList[index];
                    return Column(
                      children: [
                        CartSingleProduct(
                          quantity: cartItem.quantity ?? 0,
                          image: cartItem.image ?? '',
                          name: cartItem.name ?? '',
                          price: cartItem.price ?? 0.0,
                          onQuantityChanged: (newQuantity) {
                            productProvider.updateQuantity(cartItem.name!, newQuantity);
                            setState(() {});
                          },
                        ),
                        _buildBottomDetail(
                          startName: "Your Price",
                          endName: "\$${(cartItem.price ?? 0.0).toStringAsFixed(2)}",
                        ),
                        if (index == cartList.length - 1) ...[
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
