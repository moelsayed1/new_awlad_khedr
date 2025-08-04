class NotificationModel {
  final String timeAgo;
  final String orderDetails;
  final String orderNumber;
  final String status;

  NotificationModel({
    required this.timeAgo,
    required this.orderDetails,
    required this.orderNumber,
    required this.status,
  });
}

// New API-based notification models
class ApiNotificationResponse {
  final List<ApiNotification> data;
  final int status;
  final String message;

  ApiNotificationResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ApiNotificationResponse.fromJson(Map<String, dynamic> json) {
    return ApiNotificationResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => ApiNotification.fromJson(item))
          .toList(),
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class ApiNotification {
  final String msg;
  final String body;
  final String link;
  final String? readAt;
  final String createdAt;
  final ShippingStatus shippingStatus;
  final Transaction transaction;

  ApiNotification({
    required this.msg,
    required this.body,
    required this.link,
    this.readAt,
    required this.createdAt,
    required this.shippingStatus,
    required this.transaction,
  });

  factory ApiNotification.fromJson(Map<String, dynamic> json) {
    return ApiNotification(
      msg: json['msg'] ?? '',
      body: json['body'] ?? '',
      link: json['link'] ?? '',
      readAt: json['read_at'],
      createdAt: json['created_at'] ?? '',
      shippingStatus: ShippingStatus.fromJson(json['shipping_status'] ?? {}),
      transaction: Transaction.fromJson(json['transaction'] ?? {}),
    );
  }
}

class ShippingStatus {
  final String key;
  final String label;
  final String color;

  ShippingStatus({
    required this.key,
    required this.label,
    required this.color,
  });

  factory ShippingStatus.fromJson(Map<String, dynamic> json) {
    return ShippingStatus(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class Transaction {
  final int id;
  final String invoiceNo;
  final String status;
  final String paymentStatus;
  final String customerName;
  final String contactAddress;
  final String? shippingAddress;
  final List<TransactionProduct> products;
  final String finalTotal;
  final String createdAt;

  Transaction({
    required this.id,
    required this.invoiceNo,
    required this.status,
    required this.paymentStatus,
    required this.customerName,
    required this.contactAddress,
    this.shippingAddress,
    required this.products,
    required this.finalTotal,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      invoiceNo: json['invoice_no'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      customerName: json['customer_name'] ?? '',
      contactAddress: json['contact_address'] ?? '',
      shippingAddress: json['shipping_address'],
      products: (json['products'] as List<dynamic>?)
              ?.map((item) => TransactionProduct.fromJson(item))
              .toList() ??
          [],
      finalTotal: json['final_total'] ?? '0.00',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class TransactionProduct {
  final String name;
  final String variation;
  final int quantity;
  final String unitPrice;
  final double lineTotal;

  TransactionProduct({
    required this.name,
    required this.variation,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory TransactionProduct.fromJson(Map<String, dynamic> json) {
    return TransactionProduct(
      name: json['name'] ?? '',
      variation: json['variation'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? '0.00',
      lineTotal: double.tryParse(json['line_total'].toString()) ?? 0.0,
    );
  }
}
