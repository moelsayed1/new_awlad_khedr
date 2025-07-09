class ProductModel {
  List<Products>? products;

  ProductModel({this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add( Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productName;
  int? productId;
  String? image;
  String? minimumSoldQuantity;
  String? price;
  String? qtyAvailable;
  String? imageUrl;

  Products(
      {this.productName,
        this.productId,
        this.image,
        this.minimumSoldQuantity,
        this.price,
        this.qtyAvailable,
        this.imageUrl});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productId = json['product_id'];
    image = json['image'];
    minimumSoldQuantity = json['minimum_sold_quantity'];
    price = json['price'];
    qtyAvailable = json['qty_available'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['product_id'] = productId;
    data['image'] = image;
    data['minimum_sold_quantity'] = minimumSoldQuantity;
    data['price'] = price;
    data['qty_available'] = qtyAvailable;
    data['image_url'] = imageUrl;
    return data;
  }
}
