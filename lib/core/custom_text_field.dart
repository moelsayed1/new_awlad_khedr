import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, this.hintText,
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
      });

  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final String? hintText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool outLine;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final double? radius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      style: const TextStyle(color: Colors.black , ),
      maxLines: maxLines,
      cursorColor: Colors.white,
      minLines: minLines,
      textAlign: TextAlign.right,
      keyboardType: inputType,
      obscureText: obscureText!,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle:const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: outLine ? OutlineInputBorder(
          borderSide:const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(radius!),
        ) :OutlineInputBorder(
          borderSide:const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(radius!),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide:const BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}