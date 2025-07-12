import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    //  this.textDirection = TextDirection.rtl,
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
  //final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
      ),
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      cursorColor: darkOrange,
      textAlign: textAlign,
      //  textDirection: _getTextDirection(),
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      //   textInputAction: textInputAction,
      //     inputFormatters: _getInputFormatters(),
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
          fontFamily: 'Roboto',
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Roboto',
        ),
        helperStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Roboto',
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontFamily: 'Roboto',
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
    switch (inputType) {
      case TextInputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextInputType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  // TextDirection _getTextDirection() {
  //   // Use LTR for numbers and email, RTL for Arabic text
  //   if (inputType == TextInputType.number ||
  //       inputType == TextInputType.phone ||
  //       inputType == TextInputType.emailAddress) {
  //     return TextDirection.ltr;
  //   }
  //   return textDirection;
  // }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.hintText = 'ابحث عن المنتجات...',
    this.onChanged,
    this.controller,
    this.onSubmitted,
  });

  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: hintText,
      onChanged: onChanged,
      controller: controller,
      onSubmitted: onSubmitted,
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      radius: 25,
      fillColor: Colors.grey.shade100,
      borderColor: Colors.transparent,
      focusedBorderColor: darkOrange,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    this.hintText = 'كلمة المرور',
    this.onChanged,
    this.controller,
    this.validator,
    this.obscureText = true,
    this.onToggleVisibility,
  });

  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: hintText,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      inputType: TextInputType.visiblePassword,
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }
}
