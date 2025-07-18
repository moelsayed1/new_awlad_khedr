class BannersModel {
  BannersModel({
    required this.data,
    required this.status,
    required this.message,
  });

  final List<Datum> data;
  final int? status;
  final String? message;

  factory BannersModel.fromJson(Map<String, dynamic> json){
    return BannersModel(
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      status: json["status"],
      message: json["message"],
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.image,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
  });

  final int? id;
  final String? title;
  final String? image;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? categoryId;
  final String? categoryName;
  final int? brandId;
  final String? brandName;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      imageUrl: json["image_url"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      brandId: json["brand_id"],
      brandName: json["brand_name"],
    );
  }

}
