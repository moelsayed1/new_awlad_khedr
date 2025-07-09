class RegistrationResponse {
  String? status;
  RegistrationData? data;
  String? message;

  RegistrationResponse({this.status, this.data, this.message});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'],
      data: json['data'] != null ? RegistrationData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class RegistrationData {
  String? supplierBusinessName;
  String? firstName;
  String? commercialRegisterImage;
  String? marketImage;
  String? taxCardImage;
  String? mobile;
  String? addressLine1;
  String? email;
  String? name;
  String? type;
  int? businessId;
  int? userId;
  int? createdBy;
  String? creditLimit;
  String? contactId;
  String? updatedAt;
  String? createdAt;
  int? id;

  RegistrationData({
    this.supplierBusinessName,
    this.firstName,
    this.commercialRegisterImage,
    this.marketImage,
    this.taxCardImage,
    this.mobile,
    this.addressLine1,
    this.email,
    this.name,
    this.type,
    this.businessId,
    this.userId,
    this.createdBy,
    this.creditLimit,
    this.contactId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      supplierBusinessName: json['supplier_business_name'],
      firstName: json['first_name'],
      commercialRegisterImage: json['commercial_register_image'],
      marketImage: json['supplier_business_image'],
      taxCardImage: json['tax_card_image'],
      mobile: json['mobile'],
      addressLine1: json['address_line_1'],
      email: json['email'],
      name: json['name'],
      type: json['type'],
      businessId: json['business_id'],
      userId: json['user_id'],
      createdBy: json['created_by'],
      creditLimit: json['credit_limit'],
      contactId: json['contact_id'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}
