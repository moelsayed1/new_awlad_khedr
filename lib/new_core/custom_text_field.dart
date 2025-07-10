import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../new_core/utils/english_digits_input_formatter.dart';
import '../constant.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.onChanged,
    this.inputType,
    this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.radius = 20,
    this.maxLines = 1,
    this.minLines = 1,
    this.suffixIcon,
    this.outLine = false,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.labelText,
    this.helperText,
    this.errorText,
    this.fillColor = Colors.white,
    this.borderColor = Colors.grey,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textAlign = TextAlign.right,
    this.inputFormatters,
    this.textDirection,
    this.style, ValueChanged<String>? onFieldSubmitted,
  });

  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool outLine;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double radius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final Color fillColor;
  final Color borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isNumber = inputType == TextInputType.number || inputType == TextInputType.phone;
    final effectiveTextDirection = textDirection ?? _getTextDirection();
    final effectiveInputFormatters = inputFormatters ?? _getInputFormatters();
    final effectiveStyle = style ?? (isNumber
        ? const TextStyle(fontFamily: 'Roboto', fontSize: 16)
        : const TextStyle(color: Colors.black, fontFamily: 'Roboto'));

    return TextFormField(
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      style: effectiveStyle,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      cursorColor: darkOrange,
      textAlign: textAlign,
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      textInputAction: textInputAction,
      inputFormatters: effectiveInputFormatters,
      textDirection: effectiveTextDirection,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        focusColor: focusedBorderColor ?? darkOrange,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: baseFont,
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: baseFont,
        ),
        helperStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: baseFont,
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontFamily: baseFont,
        ),
        enabledBorder: _buildBorder(borderColor),
        focusedBorder: _buildBorder(focusedBorderColor ?? darkOrange),
        errorBorder: _buildBorder(errorBorderColor ?? Colors.red),
        focusedErrorBorder: _buildBorder(errorBorderColor ?? Colors.red),
        disabledBorder: _buildBorder(Colors.grey.shade300),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    // If the field is a password (obscureText == true), allow all characters (no formatter).
    if (obscureText) {
      // If user provided custom inputFormatters, use them, else allow all input.
      return inputFormatters;
    }
    switch (inputType) {
      case TextInputType.number:
      case TextInputType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          EnglishDigitsInputFormatter(),
        ];
      default:
        return inputFormatters;
    }
  }

  TextDirection _getTextDirection() {
    if (inputType == TextInputType.number ||
        inputType == TextInputType.phone ||
        inputType == TextInputType.emailAddress) {
      return TextDirection.ltr;
    }
    return TextDirection.rtl;
  }
} 