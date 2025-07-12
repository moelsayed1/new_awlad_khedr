import 'package:flutter/material.dart';
import '../../new_core/custom_text_field.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const SearchWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomTextField(
        controller: widget.controller,
        hintText: widget.hintText ?? 'أبحث عن منتجاتك',
        textDirection: TextDirection.rtl,
        prefixIcon: const Icon(Icons.search),
        // The following parameters are not defined in CustomTextField:
        // fillColor, borderColor, radius, textAlign, onChanged, onSubmitted
        // Instead, use the correct ones as per CustomTextField definition:
        inputType: TextInputType.text,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
      ),
    );
  }
}
