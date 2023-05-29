class ServiceListModel {
  final String id;
  final String name;
  final List<Product> product;

  ServiceListModel({required this.id, required this.name, required this.product});

  factory ServiceListModel.fromMap(Map<String, dynamic> map) {
    List<Product> products = (map['product'] as List<dynamic>)
        .map((productData) => Product.fromMap(productData))
        .toList();

    return ServiceListModel(
      id: map['id'],
      name: map['name'],
      product: products,
    );
  }
}

class Product {
  final String productId;
  final String productName;
  final String productImage;

  Product({
    required this.productId,
    required this.productName,
    required this.productImage,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'],
      productName: map['product_name'],
      productImage: map['product_image'],
    );
  }
}