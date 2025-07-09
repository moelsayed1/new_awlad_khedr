import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
        this.onTap,
        required this.text,
        required this.color,
        this.width,
        this.height,
        required this.textColor,
        required this.fontSize});

  final String text;

  final Color color;

  final double? fontSize;
  final double? width;
  final double? height;

  final Color textColor;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: color,
        ),
        child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: fontSize ?? 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                fontFamily: baseFont,

              ),
            )),
      ),
    );
  }
}