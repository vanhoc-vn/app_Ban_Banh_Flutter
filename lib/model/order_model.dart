class OrderModel {
  final String orderId;
  final List<OrderProduct> products;
  final ShippingAddress shippingAddress;
  final String status;
  final double totalAmount;
  final String userId;

  OrderModel({
    required this.orderId,
    required this.products,
    required this.shippingAddress,
    required this.status,
    required this.totalAmount,
    required this.userId,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      orderId: id,
      products:
          (map['products'] as List)
              .map((product) => OrderProduct.fromMap(product))
              .toList(),
      shippingAddress: ShippingAddress.fromMap(map['shippingAddress']),
      status: map['status'] ?? 'pending',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      userId: map['userId'] ?? '',
    );
  }
}

class OrderProduct {
  final String name;
  final double price;
  final String productId;
  final int quantity;

  OrderProduct({
    required this.name,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}

class ShippingAddress {
  final String city;
  final String state;
  final String street;
  final String zip;

  ShippingAddress({
    required this.city,
    required this.state,
    required this.street,
    required this.zip,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      city: map['city'] ?? 'Unknown',
      state: map['state'] ?? 'Unknown',
      street: map['street'] ?? 'Unknown',
      zip: map['zip'] ?? 'Unknown',
    );
  }
}
