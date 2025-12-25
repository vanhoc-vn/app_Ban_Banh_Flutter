class Product {
  final String? id;
  final String? description;
  final String name;
  final String image;
  final double price;
  final bool? isAvailable;

  Product({
    this.id,
    this.description,
    required this.image,
    required this.name,
    required this.price,
    this.isAvailable,
  });

  // Chuyển đối tượng Product thành Map để lưu lên Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      // Ánh xạ biến description trong code thành trường 'product_details' trên Firebase
      'product_details': description,
      'image': image,
      'isAvailable': isAvailable ?? true,
    };
  }

  // Tạo đối tượng Product từ dữ liệu Map lấy về từ Firebase
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      // Ưu tiên lấy dữ liệu từ 'product_details', nếu không có mới tìm 'description'
      description: map['product_details'] ?? map['description'] ?? 'Chưa có mô tả cho sản phẩm này.',
      image: map['image'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  // Chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return toMap();
  }

  // Tạo đối tượng từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product.fromMap(json);
  }

  // Tạo bản sao của Product với một vài trường được thay đổi
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? image,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}