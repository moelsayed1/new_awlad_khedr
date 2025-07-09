import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../constant.dart';
import 'dart:developer';
import '../../../../../main.dart';
import '../../../model/product_by_category_model.dart';

class CustomCategorySelector extends StatefulWidget {
  final Function(int) onCategorySelected; // Callback to notify the parent widget

  const CustomCategorySelector({super.key, required this.onCategorySelected});

  @override
  _CustomCategorySelectorState createState() => _CustomCategorySelectorState();
}

class _CustomCategorySelectorState extends State<CustomCategorySelector> {
  ProductByCategoryModel? productByCategoryItem;
  int selectedIndex = 0;
  bool isListLoaded = false;

  /// Fetches the list of categories from the API
  Future<void> GetProductByCategoryModel() async {
    try {
      Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
      final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
      if (response.statusCode == 200) {
        productByCategoryItem =
            ProductByCategoryModel.fromJson(jsonDecode(response.body));
        setState(() {
          isListLoaded = true;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      log("Error fetching categories: $error");
      setState(() {
        isListLoaded = true;
      });
    }
  }

  @override
  void initState() {
    GetProductByCategoryModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isListLoaded
        ? Directionality(
      textDirection: TextDirection.rtl, // Support RTL layout
      child: SizedBox(
        width: double.infinity,
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productByCategoryItem?.categories.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final category = productByCategoryItem!.categories[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onCategorySelected(category.categoryId!); // Notify parent widget
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? darkOrange
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: selectedIndex == index
                        ? darkOrange
                        : Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    category.categoryName ?? "No Name",
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
