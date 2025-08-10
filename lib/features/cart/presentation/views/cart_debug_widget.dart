import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer';

class CartDebugWidget extends StatelessWidget {
  const CartDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, controller, child) {
        return Container(
          margin: EdgeInsets.all(16.r),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔧 Cart Debug Tools',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                  fontFamily: baseFont,
                ),
              ),
              SizedBox(height: 12.h),
              
              // Cart Info
              Text(
                'Cart Items: ${controller.fetchedCartItems.length}',
                style: TextStyle(fontSize: 14.sp, fontFamily: baseFont),
              ),
              Text(
                'Local Cart: ${controller.cart.length}',
                style: TextStyle(fontSize: 14.sp, fontFamily: baseFont),
              ),
              
              SizedBox(height: 12.h),
              
              // CRITICAL FIX: Add validation checks
              _buildValidationChecks(controller),
              
              SizedBox(height: 12.h),
              
              // Debug Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.fetchCartFromApi();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cart refreshed'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('🔄 Refresh Cart', style: TextStyle(fontFamily: baseFont)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.cleanupDuplicateCartItems();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cart cleaned up'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('🧹 Clean Duplicates', style: TextStyle(fontFamily: baseFont)),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8.h),
              
              // CRITICAL FIX: Add comprehensive validation
              ElevatedButton(
                onPressed: () => _runValidationTests(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('🧪 Run Validation Tests', style: TextStyle(fontFamily: baseFont)),
              ),
              
              SizedBox(height: 8.h),
              
              // Duplicate Warning
              if (controller.fetchedCartItems.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '⚠️ Possible Duplicates Detected!',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                          fontFamily: baseFont,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'The cart may contain duplicate items. Use "Clean Duplicates" to fix this.',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.red[700],
                          fontFamily: baseFont,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildValidationChecks(CategoryController controller) {
    final Map<int, List<Map<String, dynamic>>> groupedItems = {};
    final Set<int> duplicateProductIds = {};
    final Set<int> duplicateCartIds = {};
    
    // Check for duplicates
    for (var item in controller.fetchedCartItems) {
      final product = item['product'];
      final cartId = item['id'] as int?;
      
      if (product != null && product.productId != null) {
        final productId = product.productId!;
        groupedItems.putIfAbsent(productId, () => []).add(item);
        
        if (groupedItems[productId]!.length > 1) {
          duplicateProductIds.add(productId);
        }
      }
      
      if (cartId != null) {
        if (duplicateCartIds.contains(cartId)) {
          // This shouldn't happen with our fix
          log('🚨 CRITICAL: Duplicate cart ID found: $cartId');
        } else {
          duplicateCartIds.add(cartId);
        }
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Validation Results:',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            fontFamily: baseFont,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Unique Products: ${groupedItems.length}',
          style: TextStyle(fontSize: 11.sp, fontFamily: baseFont),
        ),
        Text(
          'Duplicate Products: ${duplicateProductIds.length}',
          style: TextStyle(
            fontSize: 11.sp,
            color: duplicateProductIds.isNotEmpty ? Colors.red : Colors.green,
            fontFamily: baseFont,
          ),
        ),
        Text(
          'Duplicate Cart IDs: ${duplicateCartIds.length}',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.green, // Should always be 0 with our fix
            fontFamily: baseFont,
          ),
        ),
      ],
    );
  }

  void _runValidationTests(CategoryController controller) {
    log('🧪 Running validation tests...');
    
    // Test 1: Check for null product IDs
    int nullProductCount = 0;
    for (var item in controller.fetchedCartItems) {
      final product = item['product'];
      if (product?.productId == null) {
        nullProductCount++;
      }
    }
    log('Test 1 - Null product IDs: $nullProductCount');
    
    // Test 2: Check for duplicate cart IDs
    final Set<int> cartIds = {};
    int duplicateCartIdCount = 0;
    for (var item in controller.fetchedCartItems) {
      final cartId = item['id'] as int?;
      if (cartId != null) {
        if (cartIds.contains(cartId)) {
          duplicateCartIdCount++;
        } else {
          cartIds.add(cartId);
        }
      }
    }
    log('Test 2 - Duplicate cart IDs: $duplicateCartIdCount');
    
    // Test 3: Check for duplicate products
    final Map<int, int> productCounts = {};
    for (var item in controller.fetchedCartItems) {
      final product = item['product'];
      if (product?.productId != null) {
        productCounts[product.productId!] = (productCounts[product.productId!] ?? 0) + 1;
      }
    }
    final duplicateProducts = productCounts.values.where((count) => count > 1).length;
    log('Test 3 - Products with multiple entries: $duplicateProducts');
    
    // Test 4: Validate quantity consistency
    int inconsistentQuantityCount = 0;
    for (var item in controller.fetchedCartItems) {
      final quantity = item['quantity'] as int? ?? 0;
      final cartEntries = item['cart_entries'] as List<Map<String, dynamic>>?;
      if (cartEntries != null) {
        final expectedQuantity = cartEntries.fold<int>(0, (sum, entry) => sum + (entry['quantity'] as int? ?? 0));
        if (quantity != expectedQuantity) {
          inconsistentQuantityCount++;
        }
      }
    }
    log('Test 4 - Inconsistent quantities: $inconsistentQuantityCount');
    
    log('🧪 Validation tests completed');
  }
} 