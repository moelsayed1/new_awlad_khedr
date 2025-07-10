
// Product Model
class Product {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final double? selling_price;
  final String? image;
  final int? quantity;
  final String? category;
  final bool? is_active;
  final String? created_at;
  final String? updated_at;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.selling_price,
    this.image,
    this.quantity,
    this.category,
    this.is_active,
    this.created_at,
    this.updated_at,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      selling_price: json['selling_price']?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      category: json['category'],
      is_active: json['is_active'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'selling_price': selling_price,
      'image': image,
      'quantity': quantity,
      'category': category,
      'is_active': is_active,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Banner Model
class Banner {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? link;
  final bool? is_active;
  final String? created_at;
  final String? updated_at;

  Banner({
    this.id,
    this.title,
    this.description,
    this.image,
    this.link,
    this.is_active,
    this.created_at,
    this.updated_at,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      link: json['link'],
      is_active: json['is_active'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'link': link,
      'is_active': is_active,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Category Model
class Category {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final bool? is_active;
  final String? created_at;
  final String? updated_at;

  Category({
    this.id,
    this.name,
    this.description,
    this.image,
    this.is_active,
    this.created_at,
    this.updated_at,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      is_active: json['is_active'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'is_active': is_active,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Category Products Model
class CategoryProducts {
  final Category? category;
  final List<Product>? products;

  CategoryProducts({
    this.category,
    this.products,
  });

  factory CategoryProducts.fromJson(Map<String, dynamic> json) {
    return CategoryProducts(
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      products: json['products'] != null
          ? List<Product>.from(json['products'].map((x) => Product.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category?.toJson(),
      'products': products?.map((x) => x.toJson()).toList(),
    };
  }
}

// Total Sold Model
class TotalSold {
  final int? total_quantity;
  final double? total_amount;
  final String? period;

  TotalSold({
    this.total_quantity,
    this.total_amount,
    this.period,
  });

  factory TotalSold.fromJson(Map<String, dynamic> json) {
    return TotalSold(
      total_quantity: json['total_quantity'],
      total_amount: json['total_amount']?.toDouble(),
      period: json['period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_quantity': total_quantity,
      'total_amount': total_amount,
      'period': period,
    };
  }
}

// Products Response Model
class ProductsResponse {
  final bool success;
  final String? message;
  final List<Product>? data;

  ProductsResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? List<Product>.from(json['data'].map((x) => Product.fromJson(x)))
          : null,
    );
  }
}

// Banners Response Model
class BannersResponse {
  final bool success;
  final String? message;
  final List<Banner>? data;

  BannersResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory BannersResponse.fromJson(Map<String, dynamic> json) {
    return BannersResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? List<Banner>.from(json['data'].map((x) => Banner.fromJson(x)))
          : null,
    );
  }
}

// Category Products Response Model
class CategoryProductsResponse {
  final bool success;
  final String? message;
  final List<CategoryProducts>? data;

  CategoryProductsResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory CategoryProductsResponse.fromJson(Map<String, dynamic> json) {
    return CategoryProductsResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? List<CategoryProducts>.from(
              json['data'].map((x) => CategoryProducts.fromJson(x)))
          : null,
    );
  }
}
