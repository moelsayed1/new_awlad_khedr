
// Cart Item Model
class CartItem {
  final int? id;
  final int? product_id;
  final String? product_name;
  final String? product_image;
  final double? price;
  final int? quantity;
  final double? total_price;
  final String? created_at;
  final String? updated_at;

  CartItem({
    this.id,
    this.product_id,
    this.product_name,
    this.product_image,
    this.price,
    this.quantity,
    this.total_price,
    this.created_at,
    this.updated_at,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      product_image: json['product_image'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'],
      total_price: json['total_price']?.toDouble(),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': product_id,
      'product_name': product_name,
      'product_image': product_image,
      'price': price,
      'quantity': quantity,
      'total_price': total_price,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Add to Cart Request Model
class AddToCartRequest {
  final int product_id;
  final int product_quantity;
  final double price;

  AddToCartRequest({
    required this.product_id,
    required this.product_quantity,
    required this.price,
  });

  Map<String, String> toFormData() {
    return {
      'product_id': product_id.toString(),
      'product_quantity': product_quantity.toString(),
      'price': price.toString(),
    };
  }
}

// Update Cart Request Model
class UpdateCartRequest {
  final int product_id;
  final int product_quantity;
  final double price;

  UpdateCartRequest({
    required this.product_id,
    required this.product_quantity,
    required this.price,
  });

  Map<String, String> toFormData() {
    return {
      'product_id': product_id.toString(),
      'product_quantity': product_quantity.toString(),
      'price': price.toString(),
    };
  }
}

// Cart Response Model
class CartResponse {
  final bool success;
  final String? message;
  final List<CartItem>? data;
  final double? total_amount;
  final int? total_items;

  CartResponse({
    required this.success,
    this.message,
    this.data,
    this.total_amount,
    this.total_items,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null 
          ? List<CartItem>.from(json['data'].map((x) => CartItem.fromJson(x)))
          : null,
      total_amount: json['total_amount']?.toDouble(),
      total_items: json['total_items'],
    );
  }
}

// Cart Summary Model
class CartSummary {
  final List<CartItem>? items;
  final double? subtotal;
  final double? tax;
  final double? shipping;
  final double? total;
  final int? item_count;

  CartSummary({
    this.items,
    this.subtotal,
    this.tax,
    this.shipping,
    this.total,
    this.item_count,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      items: json['items'] != null 
          ? List<CartItem>.from(json['items'].map((x) => CartItem.fromJson(x)))
          : null,
      subtotal: json['subtotal']?.toDouble(),
      tax: json['tax']?.toDouble(),
      shipping: json['shipping']?.toDouble(),
      total: json['total']?.toDouble(),
      item_count: json['item_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((x) => x.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'total': total,
      'item_count': item_count,
    };
  }
} 