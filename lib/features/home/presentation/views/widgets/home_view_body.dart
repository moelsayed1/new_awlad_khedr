import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/most_requested_products_section.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as trm;

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  List<trm.Product> _mostRequestedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchMostRequestedProducts();
  }

  void _fetchMostRequestedProducts() async {
    await Future.delayed(const Duration(seconds: 1));

    // final List<trm.Product> dummyProducts = [
    //   trm.Product(productId: 101, productName: 'شاي العروسة', price: '55', qtyAvailable: '100', image: null, imageUrl: 'https://images.unsplash.com/photo-1596700810141-86640552b7a4?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', minimumSoldQuantity: '1', totalSold: '1500'),
    //   trm.Product(productId: 102, productName: 'قهوة سريعة التحضير', price: '120', qtyAvailable: '50', image: null, imageUrl: 'https://images.unsplash.com/photo-1627429671569-87c126d58cf6?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', minimumSoldQuantity: '1', totalSold: '1200'),
    //   trm.Product(productId: 103, productName: 'أرز فاخر', price: '30', qtyAvailable: '200', image: null, imageUrl: 'https://images.unsplash.com/photo-1574673809071-c0a1a0e1b6f0?q=80&w=1968&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', minimumSoldQuantity: '5', totalSold: '900'),
    //   trm.Product(productId: 104, productName: 'زيت نباتي', price: '60', qtyAvailable: '150', image: null, imageUrl: 'https://images.unsplash.com/photo-1601662528352-aa382410a830?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', minimumSoldQuantity: '1', totalSold: '800'),
    //   trm.Product(productId: 105, productName: 'مكرونة', price: '20', qtyAvailable: '300', image: null, imageUrl: 'https://images.unsplash.com/photo-1621980757049-74a46a788e0b?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', minimumSoldQuantity: '1', totalSold: '750'),
    // ];

    // setState(() {
    //   _mostRequestedProducts = dummyProducts;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.h),
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'ابحث عن منتجاتك',
                hintStyle: TextStyle(fontFamily: baseFont, color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(height: 20.h), // Space after search bar

          // --- CAROUSEL WITH INDICATOR ---
          const CarouselWithIndicator(),
          SizedBox(height: 20.h), // Space after carousel

          // --- MOST REQUESTED PRODUCTS SECTION ---
          MostRequestedProductsSection(
            products: _mostRequestedProducts,
          ),
          SizedBox(height: 20.h), // Space after most requested products

          // Categories Section (Placeholder)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المزيد',
                  style: TextStyle(fontSize: 16.sp, color: Colors.orange, fontFamily: baseFont),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  'الأصناف',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: baseFont),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 150.w,
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(child: Text('Category ${index + 1}', style: const TextStyle(fontFamily: baseFont))),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}