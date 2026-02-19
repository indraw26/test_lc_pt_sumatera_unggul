class Product {
  final int? id;
  final String code;
  final String name;
  final String description;
  final int price;
  final int qty;

  const Product({
    this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.price,
    required this.qty,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'price': price,
      'qty': qty,
    };
  }

  Product copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    int? price,
    int? qty,
  }) {
    return Product(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }
}
