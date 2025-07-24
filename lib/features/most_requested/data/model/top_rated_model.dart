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
    int? parsedProductId;
    if (json['product_id'] is int) {
      parsedProductId = json['product_id'] as int;
    } else if (json['product_id'] is String) {
      parsedProductId = int.tryParse(json['product_id']);
    }

    dynamic parsedPrice = json['product_price'] ?? json['price'] ?? 0.0;
    // Defensive: If price is null, set to 0.0
    if (parsedPrice == null) {
      parsedPrice = 0.0;
    } else if (parsedPrice is String) {
      // Try to parse string to double, fallback to original string if fails
      final tryDouble = double.tryParse(parsedPrice);
      if (tryDouble != null) {
        parsedPrice = tryDouble;
      }
      // else leave as string (could be "N/A" or similar)
    }

    return Product(
      productId: parsedProductId,
      productName: json['product_name'] as String?,
      price: parsedPrice,
      qtyAvailable: json['qty_available'],
      minimumSoldQuantity: json['minimum_sold_quantity']?.toString(),
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'qty_available': qtyAvailable,
      'minimum_sold_quantity': minimumSoldQuantity,
      'image': image,
      'image_url': imageUrl,
      'category_name': categoryName,
    };
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
