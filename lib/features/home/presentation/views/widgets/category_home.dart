import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';

import 'package:awlad_khedr/core/app_router.dart';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awlad_khedr/main.dart';


class HomeCategory extends StatefulWidget {
  const HomeCategory({
    super.key,
  });

  @override
  State<HomeCategory> createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  ProductByCategoryModel? productByCategory;

  bool isListLoaded = false;

  Future<void> GetProductByCategory() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
    final response = await http.get(
      uriToSend,
      headers: {
        "Authorization":
            "Bearer ${authToken.isNotEmpty ? authToken : (await SharedPreferences.getInstance()).getString('token') ?? ''}"
      },
    );
    if (response.statusCode == 200) {
      productByCategory =
          ProductByCategoryModel.fromJson(jsonDecode(response.body));
    }
    if (mounted) {
      setState(() {
        isListLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GetProductByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    productByCategory?.categories
        .removeWhere((category) => category.categoryName == 'operation');
    return SizedBox(
        width: double.infinity,
        height: 200.h,
        child: isListLoaded
            ? ListView.separated(
                itemCount: min(productByCategory?.categories.length ?? 0, 10),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: 15,
                ),
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        final category = productByCategory!.categories[index];
                        GoRouter.of(context).push(
                          AppRouter.kCategoryProductsPage,
                          extra: {
                            'bannerTitle': category.categoryName,
                            'categoryName': category.categoryName,
                            'categoryId': category.categoryId,
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * .4,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height * .15,
                              color: Colors.transparent,
                              child: Image.network(
                                productByCategory!.categories[index].categoryImage ?? '',
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * .15,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AssetsData.logoPng,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  productByCategory!
                                      .categories[index].categoryName!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: baseFont),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                ),
              ));
  }
}
