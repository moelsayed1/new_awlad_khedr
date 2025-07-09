import 'dart:convert';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../constant.dart';
import '../../../../../main.dart';

class ProductItemByCategory extends StatefulWidget {
  final int selectedCategoryId; // Receive selectedCategoryId

  const ProductItemByCategory({super.key, required this.selectedCategoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductItemByCategory> {
  ProductByCategoryModel? productByCategoryModel;
  bool isProductsLoaded = false;

  Future<void> GetAllProductsByCategory() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
    final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      productByCategoryModel =
          ProductByCategoryModel.fromJson(jsonDecode(response.body));
    }
    setState(() {
      isProductsLoaded = true;
    });
  }

  @override
  void initState() {
    GetAllProductsByCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Find the selected category
    final selectedCategory = productByCategoryModel?.categories.firstWhere(
            (category) => category.categoryId == widget.selectedCategoryId,
        orElse: () => Category(
            categoryId: widget.selectedCategoryId,
            categoryName: '',
            categoryImage: '',
            products: [],
            subCategories: []));

    final products = selectedCategory?.products ?? [];

    return isProductsLoaded
        ? products.isNotEmpty
        ? Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.separated(
          itemCount: products.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(
            height: 15,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            final product = products[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]),
                        child: (product.imageUrl != null && product.imageUrl!.isNotEmpty && product.imageUrl! != 'https://erp.khedrsons.com/uploads/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png')
                            ? Image.network(
                                product.imageUrl!,
                                fit: BoxFit.contain,
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${product.minimumSoldQuantity}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              product.productPrice ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    )
        : const Directionality(
      textDirection: TextDirection.rtl,
      child: Center(child: Text('لا توجد منتجات لهذه الفئة' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 , color: Colors.black),)),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
