class CartModel {
  final String name;
  final String image;
  double price;
  int quantity;

  CartModel({
    required this.price,
    required this.name,
    required this.image,
    required this.quantity,
  });
}
// Đại diện cho 1 sản phẩm trong giỏ hàng
