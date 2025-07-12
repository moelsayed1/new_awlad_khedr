class ProductModel {
  final int? productId;
  final String? productName;
  final String? productPrice;
  final dynamic qtyAvailable;
  final dynamic minimumSoldQuantity;
  final String? image;
  final String? imageUrl;
  final String? description;
  final String? category;
  final bool? isAvailable;
  final double? rating;
  final int? reviewCount;
  final bool? isFavorite;
  final int? quantity;

  ProductModel({
    this.productId,
    this.productName,
    this.productPrice,
    this.qtyAvailable,
    this.minimumSoldQuantity,
    this.image,
    this.imageUrl,
    this.description,
    this.category,
    this.isAvailable,
    this.rating,
    this.reviewCount,
    this.isFavorite = false,
    this.quantity = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json["product_id"],
      productName: json["product_name"],
      productPrice: json["product_price"],
      qtyAvailable: json["qty_available"],
      minimumSoldQuantity: json["minimum_sold_quantity"],
      image: json["image"],
      imageUrl: json["image_url"],
      description: json["description"],
      category: json["category"],
      isAvailable: json["is_available"] ?? true,
      rating: json["rating"]?.toDouble(),
      reviewCount: json["review_count"],
      isFavorite: json["is_favorite"] ?? false,
      quantity: json["quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "product_name": productName,
      "product_price": productPrice,
      "qty_available": qtyAvailable,
      "minimum_sold_quantity": minimumSoldQuantity,
      "image": image,
      "image_url": imageUrl,
      "description": description,
      "category": category,
      "is_available": isAvailable,
      "rating": rating,
      "review_count": reviewCount,
      "is_favorite": isFavorite,
      "quantity": quantity,
    };
  }

  ProductModel copyWith({
    int? productId,
    String? productName,
    String? productPrice,
    dynamic qtyAvailable,
    dynamic minimumSoldQuantity,
    String? image,
    String? imageUrl,
    String? description,
    String? category,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    int? quantity,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      qtyAvailable: qtyAvailable ?? this.qtyAvailable,
      minimumSoldQuantity: minimumSoldQuantity ?? this.minimumSoldQuantity,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;

  @override
  String toString() {
    return 'ProductModel(productId: $productId, productName: $productName, productPrice: $productPrice)';
  }
}

class CategoryModel {
  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final String? categoryDescription;
  final bool? isActive;

  CategoryModel({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.categoryDescription,
    this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      categoryImage: json["category_image"],
      categoryDescription: json["category_description"],
      isActive: json["is_active"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "category_name": categoryName,
      "category_image": categoryImage,
      "category_description": categoryDescription,
      "is_active": isActive,
    };
  }

  CategoryModel copyWith({
    int? categoryId,
    String? categoryName,
    String? categoryImage,
    String? categoryDescription,
    bool? isActive,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryImage: categoryImage ?? this.categoryImage,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.categoryId == categoryId;
  }

  @override
  int get hashCode => categoryId.hashCode;

  @override
  String toString() {
    return 'CategoryModel(categoryId: $categoryId, categoryName: $categoryName)';
  }
}
