import 'dart:convert';
import 'dart:io';
import 'package:awlad_khedr/features/auth/register/data/models/register_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import '../../../../../constant.dart';

class RegistrationService {
  final String apiUrl = APIConstant.REGISTRER_USER;

  Future<RegistrationResponse?> registerUser(
      Map<String, dynamic> requestBody,
      {File? taxCardImage, File? commercialRegisterImage, File? marketImage}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.fields.addAll(requestBody.map((key, value) => MapEntry(key, value.toString())));
      request.fields['allow_mob'] = '1';

      if (taxCardImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('tax_card_image', taxCardImage.path),
        );
      }
      if (commercialRegisterImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('commercial_register_image', commercialRegisterImage.path),
        );
      }
      if (marketImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('supplier_business_image', marketImage.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        log(RegistrationResponse.fromJson(jsonDecode(responseData.body)).toString());
        return RegistrationResponse.fromJson(jsonDecode(responseData.body));
      } else {
        log('Registration failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error during registration: $e');
      return null;
    }
  }
}
