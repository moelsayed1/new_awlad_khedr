// This model is for the general "GetAllProducts" API used by HomeProductItem
class ProductForAllProducts {
  ProductForAllProducts({
    this.productId,
    this.productName,
    this.productPrice, // This one has 'productPrice'
    this.qtyAvailable,
    this.minimumSoldQuantity,
    this.image,
    this.imageUrl,
  });

  final int? productId;
  final String? productName;
  final String? productPrice; // This is the field for general products
  final dynamic qtyAvailable; // Consider making this String or int consistently
  final dynamic minimumSoldQuantity; // Consider making this String or int consistently
  final String? image;
  final String? imageUrl;

  factory ProductForAllProducts.fromJson(Map<String, dynamic> json){
    return ProductForAllProducts(
      productId: json["product_id"],
      productName: json["product_name"],
      productPrice: json["product_price"], // Make sure JSON key matches
      qtyAvailable: json["qty_available"],
      minimumSoldQuantity: json["minimum_sold_quantity"],
      image: json["image"],
      imageUrl: json["image_url"],
    );
  }
}