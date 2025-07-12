import 'package:flutter/services.dart';

class EnglishDigitsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    
    // Replace Arabic-Indic digits (٠-٩) with English digits
    newText = newText.replaceAllMapped(
      RegExp(r'[٠-٩]'),
      (match) => (match.group(0)!.codeUnitAt(0) - 0x0660).toString(),
    );
    
    // Replace Persian digits (۰-۹) with English digits
    newText = newText.replaceAllMapped(
      RegExp(r'[۰-۹]'),
      (match) => (match.group(0)!.codeUnitAt(0) - 0x06F0).toString(),
    );

    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
} 