import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant.dart';
import '../../new_core/assets.dart';
import '../../Api/models/product_models.dart' as api_models;

class HomeCategory extends StatelessWidget {
  final List<api_models.Category> categories;
  final Function(api_models.Category)? onCategoryTap;

  const HomeCategory({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 15),
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () => onCategoryTap?.call(category),
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
                            child: (category.image != null &&
                                    category.image!.isNotEmpty)
                                ? Image.network(
                                    category.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AssetsData.logoPng,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category.name ?? 'Category',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: baseFont,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
