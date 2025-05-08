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

  // Convert Product object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
      'isAvailable': isAvailable ?? true,
    };
  }

  // Create Product object from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'],
      image: map['image'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  // Convert Product object to JSON
  Map<String, dynamic> toJson() {
    return toMap();
  }

  // Create Product object from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product.fromMap(json);
  }

  // Create a copy of Product with some fields updated
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
