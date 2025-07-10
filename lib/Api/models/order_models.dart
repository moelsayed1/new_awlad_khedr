import 'dart:convert';

// Order Model
class Order {
  final int? id;
  final String? order_number;
  final String? status;
  final double? total_amount;
  final String? payment_status;
  final String? payment_method;
  final String? shipping_address;
  final String? billing_address;
  final String? customer_name;
  final String? customer_email;
  final String? customer_phone;
  final List<OrderItem>? items;
  final String? created_at;
  final String? updated_at;

  Order({
    this.id,
    this.order_number,
    this.status,
    this.total_amount,
    this.payment_status,
    this.payment_method,
    this.shipping_address,
    this.billing_address,
    this.customer_name,
    this.customer_email,
    this.customer_phone,
    this.items,
    this.created_at,
    this.updated_at,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      order_number: json['order_number'],
      status: json['status'],
      total_amount: json['total_amount']?.toDouble(),
      payment_status: json['payment_status'],
      payment_method: json['payment_method'],
      shipping_address: json['shipping_address'],
      billing_address: json['billing_address'],
      customer_name: json['customer_name'],
      customer_email: json['customer_email'],
      customer_phone: json['customer_phone'],
      items: json['items'] != null
          ? List<OrderItem>.from(
              json['items'].map((x) => OrderItem.fromJson(x)))
          : null,
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': order_number,
      'status': status,
      'total_amount': total_amount,
      'payment_status': payment_status,
      'payment_method': payment_method,
      'shipping_address': shipping_address,
      'billing_address': billing_address,
      'customer_name': customer_name,
      'customer_email': customer_email,
      'customer_phone': customer_phone,
      'items': items?.map((x) => x.toJson()).toList(),
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Order Item Model
class OrderItem {
  final int? id;
  final int? product_id;
  final String? product_name;
  final String? product_image;
  final double? price;
  final int? quantity;
  final double? total_price;

  OrderItem({
    this.id,
    this.product_id,
    this.product_name,
    this.product_image,
    this.price,
    this.quantity,
    this.total_price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      product_image: json['product_image'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'],
      total_price: json['total_price']?.toDouble(),
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
    };
  }
}

// Transaction Model
class Transaction {
  final int? id;
  final String? transaction_id;
  final String? type;
  final double? amount;
  final String? status;
  final String? payment_method;
  final String? description;
  final String? created_at;
  final String? updated_at;

  Transaction({
    this.id,
    this.transaction_id,
    this.type,
    this.amount,
    this.status,
    this.payment_method,
    this.description,
    this.created_at,
    this.updated_at,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      transaction_id: json['transaction_id'],
      type: json['type'],
      amount: json['amount']?.toDouble(),
      status: json['status'],
      payment_method: json['payment_method'],
      description: json['description'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transaction_id,
      'type': type,
      'amount': amount,
      'status': status,
      'payment_method': payment_method,
      'description': description,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Store Sell Request Model
class StoreSellRequest {
  final bool mobile;

  StoreSellRequest({
    required this.mobile,
  });

  Map<String, String> toFormData() {
    return {
      'mobile': mobile.toString(),
    };
  }
}

// Orders Response Model
class OrdersResponse {
  final bool success;
  final String? message;
  final List<Order>? data;

  OrdersResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? List<Order>.from(json['data'].map((x) => Order.fromJson(x)))
          : null,
    );
  }
}

// Transactions Response Model
class TransactionsResponse {
  final bool success;
  final String? message;
  final List<Transaction>? data;

  TransactionsResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? List<Transaction>.from(
              json['data'].map((x) => Transaction.fromJson(x)))
          : null,
    );
  }
}

// Invoice Model
class Invoice {
  final int? id;
  final String? invoice_number;
  final String? order_number;
  final String? customer_name;
  final String? customer_email;
  final String? customer_phone;
  final String? billing_address;
  final String? shipping_address;
  final double? subtotal;
  final double? tax;
  final double? shipping;
  final double? total;
  final String? status;
  final String? payment_status;
  final String? payment_method;
  final List<InvoiceItem>? items;
  final String? created_at;
  final String? updated_at;

  Invoice({
    this.id,
    this.invoice_number,
    this.order_number,
    this.customer_name,
    this.customer_email,
    this.customer_phone,
    this.billing_address,
    this.shipping_address,
    this.subtotal,
    this.tax,
    this.shipping,
    this.total,
    this.status,
    this.payment_status,
    this.payment_method,
    this.items,
    this.created_at,
    this.updated_at,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoice_number: json['invoice_number'],
      order_number: json['order_number'],
      customer_name: json['customer_name'],
      customer_email: json['customer_email'],
      customer_phone: json['customer_phone'],
      billing_address: json['billing_address'],
      shipping_address: json['shipping_address'],
      subtotal: json['subtotal']?.toDouble(),
      tax: json['tax']?.toDouble(),
      shipping: json['shipping']?.toDouble(),
      total: json['total']?.toDouble(),
      status: json['status'],
      payment_status: json['payment_status'],
      payment_method: json['payment_method'],
      items: json['items'] != null
          ? List<InvoiceItem>.from(
              json['items'].map((x) => InvoiceItem.fromJson(x)))
          : null,
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoice_number,
      'order_number': order_number,
      'customer_name': customer_name,
      'customer_email': customer_email,
      'customer_phone': customer_phone,
      'billing_address': billing_address,
      'shipping_address': shipping_address,
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'total': total,
      'status': status,
      'payment_status': payment_status,
      'payment_method': payment_method,
      'items': items?.map((x) => x.toJson()).toList(),
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

// Invoice Item Model
class InvoiceItem {
  final int? id;
  final int? product_id;
  final String? product_name;
  final String? product_image;
  final double? price;
  final int? quantity;
  final double? total_price;

  InvoiceItem({
    this.id,
    this.product_id,
    this.product_name,
    this.product_image,
    this.price,
    this.quantity,
    this.total_price,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      product_image: json['product_image'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'],
      total_price: json['total_price']?.toDouble(),
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
    };
  }
}
