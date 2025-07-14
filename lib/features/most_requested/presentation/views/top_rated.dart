import 'dart:convert';
import 'dart:math';

import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constant.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import 'package:awlad_khedr/core/app_router.dart';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:go_router/go_router.dart';

class TopRatedItem extends StatefulWidget {
  const TopRatedItem({super.key,});

  @override
  State<TopRatedItem> createState() => _TopRatedItemState();
}

class _TopRatedItemState extends State<TopRatedItem> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;

  // Add category list
  List<Category> categories = [];

  GetTopRatedItems() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_TOP_RATED_ITEMS);
    final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
    }
    if (mounted) {
      setState(() {
        isListLoaded = true;
      });
    }
  }

  Future<void> fetchCategories() async {
    try {
      Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
      final response = await http.get(uriToSend, headers: {"Authorization": "Bearer $authToken"});
      if (response.statusCode == 200) {
        final model = ProductByCategoryModel.fromJson(jsonDecode(response.body));
        categories = model.categories;
      }
    } catch (e) {
      // ignore errors for now
    }
  }

  @override
  void initState() {
    super.initState();
    GetTopRatedItems();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: isListLoaded
          ? ListView.separated(
              itemCount: min(topRatedItem?.products.length ?? 0, 10),
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                width: 15.w,
              ),
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              reverse: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      final product = topRatedItem!.products[index];
                      GoRouter.of(context).push(
                        '/productDetails',
                        extra: product.toJson(),
                      );
                    },
                    child: Container(
                      width: 156.w,
                      height: 120.h,
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1.r,
                            blurRadius: 2.r,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: MediaQuery.sizeOf(context).height * .18,
                            color: Colors.transparent,
                            child: (topRatedItem?.products[index].imageUrl != null &&
                                    topRatedItem!.products[index].imageUrl!.isNotEmpty &&
                                    topRatedItem!.products[index].imageUrl! != 'https://erp.khedrsons.com/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png')
                                ? Image.network(
                                    topRatedItem!.products[index].imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AssetsData.callCenter,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    AssetsData.callCenter,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const Spacer(),
                          SingleChildScrollView(
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange, size: 16.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  '4.5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Text(
                                    topRatedItem?.products[index].productName ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: baseFont,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
