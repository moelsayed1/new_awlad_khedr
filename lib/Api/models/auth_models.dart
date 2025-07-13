
// Login Request Model
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  Map<String, String> toFormData() {
    return {
      'username': username,
      'password': password,
    };
  }
}

// Login Response Model
class LoginResponse {
  final bool success;
  final String? message;
  final String? token;
  final UserData? user;

  LoginResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // If token exists, consider it a successful login
    final hasToken = json['token'] != null;
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

// User Data Model
class UserData {
  final int? id;
  final String? first_name;
  final String? surname;
  final String? email;
  final String? username;
  final String? mobile;
  final String? address_line_1;
  final String? supplier_business_name;
  final String? allow_mob;
  final String? tax_card_image;
  final String? commercial_register_image;

  UserData({
    this.id,
    this.first_name,
    this.surname,
    this.email,
    this.username,
    this.mobile,
    this.address_line_1,
    this.supplier_business_name,
    this.allow_mob,
    this.tax_card_image,
    this.commercial_register_image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      first_name: json['first_name'],
      surname: json['surname'],
      email: json['email'],
      username: json['username'],
      mobile: json['mobile'],
      address_line_1: json['address_line_1'],
      supplier_business_name: json['supplier_business_name'],
      allow_mob: json['allow_mob'],
      tax_card_image: json['tax_card_image'],
      commercial_register_image: json['commercial_register_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'surname': surname,
      'email': email,
      'username': username,
      'mobile': mobile,
      'address_line_1': address_line_1,
      'supplier_business_name': supplier_business_name,
      'allow_mob': allow_mob,
      'tax_card_image': tax_card_image,
      'commercial_register_image': commercial_register_image,
    };
  }
}

// Register Request Model
class RegisterRequest {
  final String surname;
  final String first_name;
  final String email;
  final String username;
  final String password;
  final String allow_mob;
  final String mobile;
  final String address_line_1;
  final String supplier_business_name;
  final String? tax_card_image;
  final String? commercial_register_image;

  RegisterRequest({
    required this.surname,
    required this.first_name,
    required this.email,
    required this.username,
    required this.password,
    required this.allow_mob,
    required this.mobile,
    required this.address_line_1,
    required this.supplier_business_name,
    this.tax_card_image,
    this.commercial_register_image,
  });

  Map<String, String> toFormData() {
    Map<String, String> data = {
      'surname': surname,
      'first_name': first_name,
      'email': email,
      'username': username,
      'password': password,
      'allow_mob': allow_mob,
      'mobile': mobile,
      'address_line_1': address_line_1,
      'supplier_business_name': supplier_business_name,
    };

    if (tax_card_image != null) {
      data['tax_card_image'] = tax_card_image!;
    }
    if (commercial_register_image != null) {
      data['commercial_register_image'] = commercial_register_image!;
    }

    return data;
  }
}

// Update User Request Model
class UpdateUserRequest {
  final String first_name;
  final String email;
  final int id;

  UpdateUserRequest({
    required this.first_name,
    required this.email,
    required this.id,
  });

  Map<String, String> toFormData() {
    return {
      'first_name': first_name,
      'email': email,
      'id': id.toString(),
    };
  }
}

// Send OTP Request Model
class SendOtpRequest {
  final String email;

  SendOtpRequest({
    required this.email,
  });

  Map<String, String> toFormData() {
    return {
      'email': email,
    };
  }
}

// Reset Password Request Model
class ResetPasswordRequest {
  final String email;
  final String otp;
  final String password;
  final String password_confirmation;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.password,
    required this.password_confirmation,
  });

  Map<String, String> toFormData() {
    return {
      'email': email,
      'otp': otp,
      'password': password,
      'password_confirmation': password_confirmation,
    };
  }
}

// Send Verification Email Request Model
class SendVerificationEmailRequest {
  final String email;

  SendVerificationEmailRequest({
    required this.email,
  });

  Map<String, String> toFormData() {
    return {
      'email': email,
    };
  }
}

// Generic API Response Model
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJson(json['data']) : null,
    );
  }
}
