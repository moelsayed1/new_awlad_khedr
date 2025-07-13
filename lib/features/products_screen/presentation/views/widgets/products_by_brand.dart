import 'dart:convert';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../constant.dart';
import '../../../../../main.dart';

class ProductItemByBrand extends StatefulWidget {
  final int selectedBrandId; // Receive selectedBrandId

  const ProductItemByBrand({super.key, required this.selectedBrandId});

  @override
  ProductItemByBrandState createState() => ProductItemByBrandState();
}

class ProductItemByBrandState extends State<ProductItemByBrand> {
  ProductByCategoryModel? productByCategoryModel;
  bool isProductsLoaded = false;
  bool isLoadingMore = false;
  bool hasMoreProducts = true;
  
  // Pagination variables
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  int currentPage = 0;
  static const int productsPerPage = 10;
  int _lastRefreshTime = 0;

  @override
  void didUpdateWidget(ProductItemByBrand oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if this is a refresh trigger
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastRefreshTime > 100) { // Small delay to avoid multiple refreshes
      _lastRefreshTime = currentTime;
      refreshData();
    }
  }

  Future<void> refreshData() async {
    // Reset pagination and reload all products
    setState(() {
      displayedProducts.clear();
      currentPage = 0;
      hasMoreProducts = true;
    });
    
    // Reload all products from API
    await GetAllProductsByBrand();
  }

  Future<void> GetAllProductsByBrand() async {
    // Use the existing category products endpoint to get all products
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
    final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      productByCategoryModel =
          ProductByCategoryModel.fromJson(jsonDecode(response.body));
      
      // Get all products from all categories
      allProducts.clear();
      if (productByCategoryModel?.categories != null) {
        for (var category in productByCategoryModel!.categories) {
          allProducts.addAll(category.products);
        }
      }
      
      // Load first page
      loadNextPage();
    }
    setState(() {
      isProductsLoaded = true;
    });
  }

  void loadNextPage() {
    if (isLoadingMore || !hasMoreProducts) return;
    
    setState(() {
      isLoadingMore = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final startIndex = currentPage * productsPerPage;
      final endIndex = startIndex + productsPerPage;
      
      if (startIndex < allProducts.length) {
        final newProducts = allProducts.sublist(
          startIndex, 
          endIndex > allProducts.length ? allProducts.length : endIndex
        );
        
        setState(() {
          displayedProducts.addAll(newProducts);
          currentPage++;
          isLoadingMore = false;
          hasMoreProducts = endIndex < allProducts.length;
        });
      } else {
        setState(() {
          isLoadingMore = false;
          hasMoreProducts = false;
        });
      }
    });
  }

  @override
  void initState() {
    GetAllProductsByBrand();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isProductsLoaded
        ? displayedProducts.isNotEmpty
        ? Directionality(
      textDirection: TextDirection.rtl,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // User reached the bottom, load more products
            loadNextPage();
          }
          return true;
        },
        child: ListView.separated(
            itemCount: displayedProducts.length + (hasMoreProducts ? 1 : 0),
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(
              height: 15,
            ),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              // Show loading indicator at the bottom
              if (index == displayedProducts.length) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'جاري تحميل المزيد من المنتجات...',
                        style: TextStyle(
                          color: darkOrange,
                          fontSize: 14,
                          fontFamily: baseFont,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              final product = displayedProducts[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
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
                                color: Colors.grey[100],
                            ),
                            child: (product.imageUrl != null && product.imageUrl!.isNotEmpty && product.imageUrl! != 'https://erp.khedrsons.com/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2.0,
                                            valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Icon(Icons.image_not_supported, color: Colors.grey[400]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "الكمية المتاحة: ${product.minimumSoldQuantity}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.productPrice ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: darkOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    )
        : const Directionality(
      textDirection: TextDirection.rtl,
      child: Center(child: Text('لا توجد منتجات متاحة' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 , color: Colors.black),)),
    )
        : const Center(child: CircularProgressIndicator());
  }
} 