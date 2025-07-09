import 'dart:io';
import 'package:flutter/material.dart';
import '../models/register_model.dart';
import '../models/register_service.dart';

class RegisterProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _message;
  RegistrationData? _registeredUser;

  Map<String, dynamic> registerData = {};
  File? taxCardFile;
  File? commercialRegisterFile;
  File? marketImageFile;
  

  bool get isLoading => _isLoading;

  String? get message => _message;

  RegistrationData? get registeredUser => _registeredUser;

  final RegistrationService _registrationService = RegistrationService();

  void saveRegisterData(Map<String, dynamic> data) {
    registerData = data;
    notifyListeners();
  }

  void saveFiles({File? taxCard, File? commercialRegister, File? marketImage}) {
    if (taxCard != null) taxCardFile = taxCard;
    if (commercialRegister != null) commercialRegisterFile = commercialRegister;
    if (marketImage != null) marketImageFile = marketImage;
    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> reserveData) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {...registerData, ...reserveData};

    final response = await _registrationService.registerUser(
      requestBody,
      taxCardImage: taxCardFile,
      commercialRegisterImage: commercialRegisterFile,
      marketImage: marketImageFile,
    );

    if (response != null || response?.status == "success") {
      _registeredUser = response?.data;
      _message = response?.message;
    } else {
      _message = "Registration failed. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
  }
}
