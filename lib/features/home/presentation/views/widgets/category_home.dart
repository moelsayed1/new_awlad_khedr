import 'dart:convert';

import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:awlad_khedr/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

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

  GetProductByCategory() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
    final response = await http
        .get(uriToSend, headers: {"Authorization": "Bearer $authToken"});
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
    GetProductByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 200.h,
        child: isListLoaded
            ? ListView.separated(
                itemCount: productByCategory?.categories.length ?? 0,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: 15,
                ),
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            child: productByCategory?.categories[index] != null
                                ? Image.network(
                                    productByCategory!
                                        .categories[index].categoryImage ?? 'https://img4cdn.haraj.com.sa/userfiles30/2022-08-23/800x689-1_-GO__MTY2MTI4MDM2MzM5OTk0NDE1OTEwNQ.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/logoPng.png', fit: BoxFit.cover);
                                    },
                                  )
                                : Image.asset(
                                    AssetsData.callCenter,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                productByCategory!
                                    .categories[index].categoryName!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: baseFont),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
