// awlad_khedr/features/most_requested/data/model/top_rated_model.dart
class Product {
  final int? productId; // THIS IS IMPORTANT for unique identification
  final String? productName;
  final dynamic price;
  final dynamic qtyAvailable;
  final String? minimumSoldQuantity;
  final String? image;
  final String? imageUrl;
  final String? categoryName;

  Product({
    this.productId,
    this.productName,
    this.price,
    this.qtyAvailable,
    this.minimumSoldQuantity,
    this.image,
    this.imageUrl,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] as int?, // Ensure your API returns 'product_id'
      productName: json['product_name'] as String?,
      price: json['price'],
      qtyAvailable: json['qty_available'],
      minimumSoldQuantity: json['minimum_sold_quantity']?.toString(),
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }

  // It's good practice to override == and hashCode for objects used as map keys
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              productId == other.productId; // Compare by unique ID

  @override
  int get hashCode => productId.hashCode;
}

class TopRatedModel {
  final List<Product> products;

  TopRatedModel({required this.products});

  factory TopRatedModel.fromJson(Map<String, dynamic> json) {
    return TopRatedModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}