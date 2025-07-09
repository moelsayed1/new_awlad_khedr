class ProductByCategoryModel {
  ProductByCategoryModel({
    required this.categories,
  });

  final List<Category> categories;

  factory ProductByCategoryModel.fromJson(Map<String, dynamic> json){
    return ProductByCategoryModel(
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    );
  }

}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.products,
    required this.subCategories,
  });

  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final List<Product> products;
  final List<SubCategory> subCategories;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      categoryImage: json["category_image"],
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      subCategories: json["sub_categories"] == null ? [] : List<SubCategory>.from(json["sub_categories"]!.map((x) => SubCategory.fromJson(x))),
    );
  }

}

class Product {
  Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.qtyAvailable,
    required this.minimumSoldQuantity,
    required this.image,
    required this.imageUrl,
  });

  final int? productId;
  final String? productName;
  final String? productPrice;
  final dynamic qtyAvailable;
  final dynamic minimumSoldQuantity;
  final String? image;
  final String? imageUrl;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      productId: json["product_id"],
      productName: json["product_name"],
      productPrice: json["product_price"],
      qtyAvailable: json["qty_available"],
      minimumSoldQuantity: json["minimum_sold_quantity"],
      image: json["image"],
      imageUrl: json["image_url"],
    );
  }

}

class SubCategory {
  SubCategory({
    required this.subCategoryId,
    required this.subCategoryName,
    required this.products,
  });

  final int? subCategoryId;
  final String? subCategoryName;
  final List<dynamic> products;

  factory SubCategory.fromJson(Map<String, dynamic> json){
    return SubCategory(
      subCategoryId: json["sub_category_id"],
      subCategoryName: json["sub_category_name"],
      products: json["products"] == null ? [] : List<dynamic>.from(json["products"]!.map((x) => x)),
    );
  }

}
