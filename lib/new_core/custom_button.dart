import 'package:flutter/material.dart';
import '../constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    required this.color,
    this.width,
    this.height,
    required this.textColor,
    required this.fontSize,
    this.isLoading = false,
    this.borderRadius = 20,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  });

  final String text;
  final Color color;
  final double? fontSize;
  final double? width;
  final double? height;
  final Color textColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: color,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: isLoading ? color.withOpacity(0.7) : color,
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize ?? 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: baseFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onTap,
    required this.text,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
  });

  final String text;
  final double? fontSize;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onTap,
      text: text,
      color: darkOrange,
      textColor: Colors.white,
      width: width,
      height: height,
      fontSize: fontSize,
      isLoading: isLoading,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.onTap,
    required this.text,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
  });

  final String text;
  final double? fontSize;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onTap,
      text: text,
      color: Colors.transparent,
      textColor: darkOrange,
      width: width,
      height: height,
      fontSize: fontSize,
      isLoading: isLoading,
    );
  }
}
