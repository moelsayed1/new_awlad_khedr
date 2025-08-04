import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart'
    as top_rated;
import 'package:awlad_khedr/features/cart/services/cart_api_service.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends ChangeNotifier {
  final CategoryRepository _repository;

  bool _disposed = false;
  final Map<int, bool> cartItemDeleteLoading = {};
  bool isCartItemDeleting(int cartId) => cartItemDeleteLoading[cartId] == true;

  // CRITICAL FIX: Add atomic operation flag to prevent race conditions
  bool _isProcessingCartOperation = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  CategoryController(this._repository) {
    initializeData();
  }

  top_rated.TopRatedModel? topRatedItem;
  bool isListLoaded = false;
  List<String> categories = ['الكل'];
  String selectedCategory = 'الكل';
  final Map<String, int> productQuantities = {};
  final Map<top_rated.Product, int> cart = {};
  List<top_rated.Product> filteredProducts = [];
  String _currentSearchQuery = '';

  int currentPage = 1;
  bool hasMoreProducts = true;
  bool isLoadingProducts = false;
  final List<top_rated.Product> _allLoadedProducts = [];

  // جديد: خريطة لتخزين جميع المنتجات للبحث الفعال (مثل سلة التسوق)
  final Map<int, top_rated.Product> _allProductsById = {};
  bool _isAllProductsMapLoaded = false;

  double get cartTotal {
    double total = 0;
    cart.forEach((product, qty) {
      final price = product.price;
      double priceValue = 0;
      if (price is num) {
        priceValue = (price as num?)?.toDouble() ?? 0;
      } else if (price is String) {
        priceValue = double.tryParse(price) ?? 0;
      }
      total += priceValue * qty;
    });
    return total;
  }

  /// Preload products that are in the cart to ensure we have their names
  Future<void> preloadCartProducts() async {
    try {
      log('🔄 Preloading cart products...');
      final cartList = await _repository.fetchCartFromApi();

      if (cartList.isNotEmpty) {
        log('📦 Found ${cartList.length} items in cart, preloading products...');

        // Get unique product IDs from cart
        final Set<int> productIds = {};
        for (var item in cartList) {
          final productId = item['product_id'];
          if (productId != null) {
            productIds.add(productId);
          }
        }

        log('🔍 Preloading ${productIds.length} unique products...');

        // CRITICAL FIX: Check if products are already loaded in _allLoadedProducts
        for (int productId in productIds) {
          if (!_allProductsById.containsKey(productId)) {
            // Try to find in loaded products first
            bool foundInLoaded = false;
            if (_allLoadedProducts.isNotEmpty) {
              for (final product in _allLoadedProducts) {
                if (product.productId == productId) {
                  _allProductsById[productId] = product;
                  log('✅ Found product $productId in loaded data: ${product.productName}');
                  foundInLoaded = true;
                  break;
                }
              }
            }

            // If not found in loaded products, try to fetch from API
            if (!foundInLoaded) {
              await fetchAndCacheProduct(productId);
            }
          }
        }

        log('✅ Preloaded ${productIds.length} cart products');

        // CRITICAL FIX: Sync quantities after preloading
        await fetchCartFromApi();
      }
    } catch (e) {
      log('❌ Error preloading cart products: $e');
    }
  }

  Future<void> initializeData() async {
    isListLoaded = false;
    safeNotifyListeners();

    try {
      await fetchCategories();
      
      // CRITICAL FIX: Load products first, then preload cart products
      if (selectedCategory == 'الكل') {
        await fetchAllProducts();
      } else {
        await fetchProductsByCategory();
      }

      // Preload cart products to ensure we have their names
      await preloadCartProducts();

      filteredProducts = topRatedItem?.products ?? [];
      
      isListLoaded = true;
      safeNotifyListeners();
    } catch (e) {
      log('Error initializing data: $e');
      isListLoaded = true;
      topRatedItem = top_rated.TopRatedModel(products: []);
      filteredProducts = [];
      safeNotifyListeners();
    }
  }

  // دالة جديدة لتحميل جميع المنتجات في خريطة البحث
  Future<void> _loadAllProductsForLookup() async {
    if (_isAllProductsMapLoaded && _allProductsById.isNotEmpty) {
      log('All products lookup map already loaded.');
      return;
    }
    log('Loading all products for lookup map...');
    try {
      // Use pagination to load products in batches of 10
      int page = 1;
      bool hasMore = true;
      _allProductsById.clear();

      while (hasMore) {
        final productsBatch =
            await _repository.fetchAllProducts(page: page, pageSize: 10);
        for (var p in productsBatch) {
        if (p.productId != null) {
          _allProductsById[p.productId!] = p;
          }
        }

        // Check if we have more products to load
        hasMore = productsBatch.length == 10;
        page++;

        // Add a small delay to prevent overwhelming the server
        if (hasMore) {
          await Future.delayed(Duration(milliseconds: 100));
        }
      }

      _isAllProductsMapLoaded = true;
      log('Successfully loaded ${_allProductsById.length} products into lookup map.');
    } catch (e) {
      log('Error loading all products for lookup map: $e');
      _isAllProductsMapLoaded = false;
    }
  }

  Future<void> fetchCategories() async {
    categories = await _repository.fetchCategories();
    safeNotifyListeners();
  }

  Future<void> fetchAllProducts({bool reset = true}) async {
    if (isLoadingProducts) return;
    isLoadingProducts = true;
    if (reset) {
      isListLoaded = false;
      currentPage = 1;
      hasMoreProducts = true;
      _allLoadedProducts.clear();
      safeNotifyListeners();
    }
    try {
      final products = await _repository.fetchAllProducts(
          page: currentPage,
          pageSize: 10,
          search: _currentSearchQuery.isNotEmpty ? _currentSearchQuery : null);
      if (reset) {
        _allLoadedProducts.clear();
      }
      _allLoadedProducts.addAll(products);
      topRatedItem = top_rated.TopRatedModel(products: _allLoadedProducts);
      _updateProductQuantities(_allLoadedProducts);
      applySearchFilter(_currentSearchQuery, notify: false);
      if (products.length < 10) {
        hasMoreProducts = false;
      }
    } catch (e) {
      log('Error fetching all products: $e');
      if (reset) {
        topRatedItem = top_rated.TopRatedModel(products: []);
        _allLoadedProducts.clear();
      }
      hasMoreProducts = false;
    } finally {
      isListLoaded = true;
      isLoadingProducts = false;
      safeNotifyListeners();
    }
  }

  Future<void> fetchProductsByCategory({bool reset = true}) async {
    if (selectedCategory == null || selectedCategory.isEmpty) {
      log('No category selected');
      return;
    }
    if (isLoadingProducts) return;
    isLoadingProducts = true;
    if (reset) {
      isListLoaded = false;
      currentPage = 1;
      hasMoreProducts = true;
      _allLoadedProducts.clear();
      safeNotifyListeners();
    }
    try {
      final products = await _repository.fetchProductsByCategory(
          selectedCategory,
          page: currentPage,
          pageSize: 10,
          search: _currentSearchQuery.isNotEmpty ? _currentSearchQuery : null);
      if (reset) {
        _allLoadedProducts.clear();
      }
      _allLoadedProducts.addAll(products);
      topRatedItem = top_rated.TopRatedModel(products: _allLoadedProducts);
      _updateProductQuantities(_allLoadedProducts);
      filteredProducts = _allLoadedProducts;
      applySearchFilter(_currentSearchQuery, notify: false);
      if (products.length < 10) {
        hasMoreProducts = false;
      }
    } catch (e) {
      log('Error fetching category products: $e');
      if (reset) {
        topRatedItem = top_rated.TopRatedModel(products: []);
        _allLoadedProducts.clear();
      }
      hasMoreProducts = false;
      filteredProducts = [];
    } finally {
      isListLoaded = true;
      isLoadingProducts = false;
      safeNotifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts || isLoadingProducts) return;
    currentPage++;
    if (selectedCategory == 'الكل') {
      await fetchAllProducts(reset: false);
    } else {
      await fetchProductsByCategory(reset: false);
    }
  }

  void _updateProductQuantities(List<top_rated.Product> products) {
    final Map<String, int> newProductQuantities = {};
    for (var product in products) {
      final String key = product.productId?.toString() ??
          product.productName ??
          UniqueKey().toString();
      // Always start with 0 quantity for new products
      newProductQuantities[key] = 0;
    }
    productQuantities.clear();
    productQuantities.addAll(newProductQuantities);
  }

  void applySearchFilter(String query, {bool notify = true}) {
    _currentSearchQuery = query;
    List<top_rated.Product> productsToFilter = _allLoadedProducts;
    if (query.isNotEmpty) {
      filteredProducts = productsToFilter.where((product) {
        return (product.productName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false);
      }).toList();
    } else {
      filteredProducts = productsToFilter;
    }
    if (notify) safeNotifyListeners();
  }

  void onCategorySelected(String category) {
    selectedCategory = category;
    _currentSearchQuery = ''; 
    safeNotifyListeners(); 
  }

  void onQuantityChanged(String productKey, int newQuantity) {
    productQuantities[productKey] = newQuantity;
    safeNotifyListeners();
  }

  // Helper method to update cart item quantity
  void updateCartItemQuantity(top_rated.Product product, int newQuantity) {
    if (newQuantity > 0) {
      cart[product] = newQuantity;
    } else {
      cart.remove(product);
    }
    safeNotifyListeners();
  }

  // Helper method to remove item from cart
  void removeFromCart(top_rated.Product product) {
    cart.remove(product);
    safeNotifyListeners();
  }

  // Helper method to remove product from cart via API
  Future<bool> removeProductFromCart(top_rated.Product product) async {
    log('CategoryController.removeProductFromCart called for productId: ${product.productId}');

    // Find the cart item to remove
    Map<String, dynamic>? cartItemToRemove;
    try {
      cartItemToRemove = fetchedCartItems.firstWhere(
        (item) {
          final itemProduct = item['product'] as top_rated.Product;
          return itemProduct.productId != null &&
              product.productId != null &&
              itemProduct.productId == product.productId;
        },
      );
    } catch (e) {
      // Product not found in cart
      return true; // Consider it already removed
    }

    if (cartItemToRemove != null) {
      final cartId = cartItemToRemove['id'];
      final success = await CartApiService.deleteCartItem(cartId: cartId);
      if (success) {
        // CRITICAL FIX: Remove from all local data consistently
        fetchedCartItems.removeWhere((item) => item['id'] == cartId);
        cart.remove(product);

        // Update local quantities
        final String quantityKey = product.productId?.toString() ??
            product.productName ??
            'product_${product.productId}';
        productQuantities[quantityKey] = 0;

        log('🗑️ Removed cart item: ${product.productName}');
        safeNotifyListeners();
        log('✅ CartSheet will be updated with removed item');
      }
      return success;
    }
    return false;
  }

  void addToCart(top_rated.Product product) {
    cart[product] = (cart[product] ?? 0) + 1;
    safeNotifyListeners();
  }

  void clearCart() {
    cart.clear();
    productQuantities.updateAll((key, value) => 0);
    safeNotifyListeners();
  }

  /// Clean up duplicate cart items on the server
  Future<void> cleanupDuplicateCartItems() async {
    log('🧹 Starting cart cleanup...');

    final Map<int, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in fetchedCartItems) {
      final product = item['product'] as top_rated.Product;
      final productId = product.productId;
      if (productId != null) {
        groupedItems.putIfAbsent(productId, () => []).add(item);
      }
    }

    for (var entry in groupedItems.entries) {
      final productId = entry.key;
      final items = entry.value;

      if (items.length > 1) {
        log('🧹 Found ${items.length} duplicate entries for product ID $productId');

        // Keep the first item, delete the rest
        final itemsToDelete = items.skip(1).toList();
        for (var itemToDelete in itemsToDelete) {
          final cartId = itemToDelete['id'];
          log('🧹 Deleting duplicate cart item: Cart ID $cartId');
          await CartApiService.deleteCartItem(cartId: cartId);
        }
      }
    }

    // Refresh cart data after cleanup
    await fetchCartFromApi();
  }

  /// Sync local product quantities with cart quantities
  void syncProductQuantitiesWithCart() {
    log('🔄 Syncing product quantities with cart...');

    // Update local quantities based on cart data, but preserve higher local quantities
    for (var item in fetchedCartItems) {
      final product = item['product'] as top_rated.Product;
      final cartQuantity = item['quantity'] as int? ?? 0;

      if (product.productId != null) {
        final key = product.productId.toString();
        final currentLocalQuantity = productQuantities[key] ?? 0;

        // CRITICAL FIX: Only update if cart quantity is higher than local quantity
        // This prevents overriding user's current selection
        if (cartQuantity > currentLocalQuantity) {
          productQuantities[key] = cartQuantity;
          log('📦 Synced product ${product.productName}: $cartQuantity (was $currentLocalQuantity)');
        } else {
          log('📦 Preserved local quantity for ${product.productName}: $currentLocalQuantity (cart: $cartQuantity)');
        }
      }
    }

    // Also sync with local cart map
    cart.clear();
    for (var item in fetchedCartItems) {
      final product = item['product'] as top_rated.Product;
      final quantity = item['quantity'] as int? ?? 0;
      cart[product] = quantity;
    }

    safeNotifyListeners();
  }

  static const String _cartBaseUrl = 'https://erp.khedrsons.com/api/cart';

  Future<bool> addProductToCart(top_rated.Product product, int quantity) async {
    log('CategoryController.addProductToCart called for productId: ${product.productId}, quantity: ${quantity}');

    // CRITICAL FIX: Add atomic operation flag to prevent race conditions
    if (_isProcessingCartOperation) {
      log('⚠️ Cart operation already in progress, skipping this request');
      return false;
    }
    _isProcessingCartOperation = true;

    try {
      // CRITICAL FIX: Preserve the current local quantity
      final String quantityKey = product.productId?.toString() ??
          product.productName ??
          'product_${product.productId}';
      final currentLocalQuantity = productQuantities[quantityKey] ?? 0;

      // Use the higher quantity between local and requested
      final finalQuantity =
          quantity > currentLocalQuantity ? quantity : currentLocalQuantity;

      log('🔍 Local quantity: $currentLocalQuantity, Requested: $quantity, Final: $finalQuantity');

      // Check if product already exists in cart with proper null safety
      Map<String, dynamic>? existingCartItem;
      try {
        existingCartItem = fetchedCartItems.firstWhere(
          (item) {
            final itemProduct = item['product'] as top_rated.Product;
            return itemProduct.productId != null &&
                product.productId != null &&
                itemProduct.productId == product.productId;
          },
        );
      } catch (e) {
        // Product not found in cart
        existingCartItem = null;
      }

      if (existingCartItem != null) {
        // Update existing cart item using CartApiService
        final cartId = existingCartItem['id'];
        final success = await CartApiService.updateCartItem(
          cartId: cartId,
          productId: product.productId ?? 0,
          quantity: finalQuantity,
          price: product.price ?? 0.0,
        );
        if (success) {
          // CRITICAL FIX: Update local cart data directly instead of fetching from API
          existingCartItem['quantity'] = finalQuantity;
          existingCartItem['total_price'] =
              (product.price ?? 0.0) * finalQuantity;
          cart[product] = finalQuantity;

          // CRITICAL FIX: Update local quantities with the final quantity
          productQuantities[quantityKey] = finalQuantity;

          // CRITICAL FIX: Don't call fetchCartFromApi() to avoid unnecessary product loading
          safeNotifyListeners();
        } else {
          // If update failed, refresh cart data to sync with API
          log('⚠️ Cart update failed, refreshing cart data...');
          await fetchCartFromApi();
        }
        return success;
      } else {
        // Add new cart item using CartApiService
        final success = await CartApiService.addProductToCart(
          productId: product.productId ?? 0,
          quantity: finalQuantity,
          price: product.price ?? 0.0,
        );
        if (success) {
          // CRITICAL FIX: Update local cart data directly instead of fetching from API
          // Create a new cart item entry
          final newCartItem = {
            'id': DateTime.now()
                .millisecondsSinceEpoch, // Temporary ID until we get real one
            'product': product,
            'quantity': finalQuantity,
            'price': product.price ?? 0.0,
            'total_price': (product.price ?? 0.0) * finalQuantity,
          };
          fetchedCartItems.add(newCartItem);
          cart[product] = finalQuantity;

          // CRITICAL FIX: Update local quantities with the final quantity
          productQuantities[quantityKey] = finalQuantity;

          // CRITICAL FIX: Don't call fetchCartFromApi() to avoid unnecessary product loading
          safeNotifyListeners();
        }
        return success;
      }
    } finally {
      _isProcessingCartOperation = false;
    }
  }

  /// Add single product to cart without fetching all cart data
  Future<bool> addSingleProductToCart(
      top_rated.Product product, int quantity) async {
    log('CategoryController.addSingleProductToCart called for productId: ${product.productId}, quantity: ${quantity}');

    // CRITICAL FIX: Add atomic operation flag to prevent race conditions
    if (_isProcessingCartOperation) {
      log('⚠️ Cart operation already in progress, skipping this request');
      return false;
    }
    _isProcessingCartOperation = true;

    try {
      // CRITICAL FIX: Check if product already exists in cart
      Map<String, dynamic>? existingCartItem;
      try {
        existingCartItem = fetchedCartItems.firstWhere(
          (item) {
            final itemProduct = item['product'] as top_rated.Product;
            return itemProduct.productId != null &&
                product.productId != null &&
                itemProduct.productId == product.productId;
          },
        );
        log('🔍 Found existing cart item: Cart ID ${existingCartItem['id']}, Product ID ${product.productId}');
      } catch (e) {
        // Product not found in cart
        existingCartItem = null;
        log('🔍 No existing cart item found for Product ID ${product.productId}');
      }

      bool success;
      if (existingCartItem != null) {
        // CRITICAL FIX: Always use UPDATE for existing items to avoid duplication
        final cartId = existingCartItem['id'];
        log('🔄 Using UPDATE for existing cart item: Cart ID $cartId, Product ID ${product.productId}, Quantity: $quantity');
        success = await CartApiService.updateCartItem(
          cartId: cartId,
          productId: product.productId ?? 0,
          quantity: quantity,
          price: product.price ?? 0.0,
        );
      } else {
        // CRITICAL FIX: Use STORE only for new items
        log('🆕 Using STORE for new cart item: Product ID ${product.productId}, Quantity: $quantity');
        success = await CartApiService.addProductToCart(
      productId: product.productId ?? 0,
      quantity: quantity,
          price: product.price ?? 0.0,
        );
      }

      if (success) {
        // CRITICAL FIX: Update all local data consistently
        final String quantityKey = product.productId?.toString() ??
            product.productName ??
            'product_${product.productId}';
        productQuantities[quantityKey] = quantity;
        cart[product] = quantity;

        // CRITICAL FIX: Update fetchedCartItems to sync with CartSheet
        if (existingCartItem != null) {
          existingCartItem['quantity'] = quantity;
          existingCartItem['total_price'] = (product.price ?? 0.0) * quantity;
          log('🔄 Updated existing cart item: ${product.productName} - Quantity: $quantity');
        } else {
          // CRITICAL FIX: For new items, we need to fetch the cart to get the real cart ID
          log('🆕 Added new cart item via API, fetching updated cart data...');
          log('📊 Current fetchedCartItems before fetch: ${fetchedCartItems.length} items');
          await fetchCartFromApi();
          log('📊 Current fetchedCartItems after fetch: ${fetchedCartItems.length} items');
          return true;
        }

        // CRITICAL FIX: Force update CartSheet immediately
        safeNotifyListeners();
        log('✅ CartSheet will be updated with new data');

        // CRITICAL FIX: Log current state for debugging
        log('📊 Current cart state:');
        for (var item in fetchedCartItems) {
          final itemProduct = item['product'] as top_rated.Product;
          log('   - ${itemProduct.productName}: ${item['quantity']} units');
        }
      }

    return success;
    } catch (e) {
      log('❌ Error in addSingleProductToCart: $e');
      return false;
    } finally {
      _isProcessingCartOperation = false;
    }
  }

  List<Map<String, dynamic>> fetchedCartItems = [];

  Future<void> fetchCartFromApi() async {
    log('CategoryController.fetchCartFromApi called');
    
    try {
    final cartList = await _repository.fetchCartFromApi();

      log('🔍 Raw cart data from API: ${cartList.length} items');
      for (var item in cartList) {
        log('   - Product ID: ${item['product_id']}, Quantity: ${item['product_quantity']}, Cart ID: ${item['id']}');
      }

      // CRITICAL FIX: Clear existing data before processing
    cart.clear();
    fetchedCartItems.clear();

      // Group items by product ID to detect duplicates
      final Map<int, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in cartList) {
      final productId = item['product_id'];
        if (productId != null) {
          groupedItems.putIfAbsent(productId, () => []).add(item);
        }
      }

      log('🔍 Grouped items by product ID:');
      for (var entry in groupedItems.entries) {
        log('   - Product ID ${entry.key}: ${entry.value.length} entries');
        for (var item in entry.value) {
          log('     * Cart ID: ${item['id']}, Quantity: ${item['product_quantity']}');
        }
      }

      // CRITICAL FIX: Process each product group with proper deduplication
      for (var entry in groupedItems.entries) {
        final productId = entry.key;
        final items = entry.value;

        // Fetch individual product if not in lookup map
        top_rated.Product? product = _allProductsById[productId];
        if (product == null) {
          // CRITICAL FIX: Try to find product in loaded products first
          if (_allLoadedProducts.isNotEmpty) {
            log('🔍 Searching for product $productId in loaded products...');
            for (final loadedProduct in _allLoadedProducts) {
              if (loadedProduct.productId == productId) {
                product = loadedProduct;
                _allProductsById[productId] = product;
                log('✅ Found product in loaded data: ${product.productName}');
                break;
              }
            }
          }

          // If still not found, try to fetch from API
          if (product == null) {
            log('⚠️ Product $productId not found in loaded data. Fetching from API...');
            product = await fetchAndCacheProduct(productId);

            if (product == null) {
              log('❌ Could not fetch product $productId from API. Creating placeholder...');
              // Create a minimal product object with better placeholder
              product = top_rated.Product(
                productId: productId,
                productName: null, // سيتم تحديثه لاحقاً من API
                price: 0.0, // Will be updated from cart data
                qtyAvailable: null,
                minimumSoldQuantity: null,
                image: null,
                imageUrl: null,
                categoryName: null,
              );
              // Cache the placeholder product
              _allProductsById[productId] = product;
            }
          }
        }

        // CRITICAL FIX: Update product price from cart data if it's 0
        if (product != null && product.price == 0.0) {
          for (var item in items) {
            final cartPrice = double.tryParse(item['price'].toString()) ?? 0.0;
            if (cartPrice > 0) {
              final originalProduct = product!;
              product = top_rated.Product(
                productId: originalProduct.productId ?? productId,
                productName: originalProduct.productName ?? 'منتج غير معروف',
                price: cartPrice,
                qtyAvailable: originalProduct.qtyAvailable,
                minimumSoldQuantity: originalProduct.minimumSoldQuantity,
                image: originalProduct.image,
                imageUrl: originalProduct.imageUrl,
                categoryName: originalProduct.categoryName,
              );
              _allProductsById[productId] = product;
              break;
            }
          }
        }

        if (product != null) {
          // CRITICAL FIX: Calculate total quantity from all cart entries for this product
          int totalQuantity = 0;
          double totalPrice = 0.0;
          final List<Map<String, dynamic>> cartEntries = [];

          for (var item in items) {
            final quantity =
                int.tryParse(item['product_quantity'].toString()) ?? 1;
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
            totalQuantity += quantity;
            totalPrice += price * quantity;
            cartEntries.add({
              'id': item['id'],
          'product': product,
          'quantity': quantity,
          'price': price,
          'total_price': price * quantity,
        });
          }

          if (items.length > 1) {
            log('⚠️ Found ${items.length} duplicate entries for product ${product.productName}. Aggregating quantities.');
          }

          // CRITICAL FIX: Add only ONE entry per product with aggregated data
          cart[product] = totalQuantity;
          fetchedCartItems.add({
            'id':
                cartEntries.first['id'], // Use first cart ID as representative
            'product': product,
            'quantity': totalQuantity,
            'price': totalPrice / totalQuantity, // Average price
            'total_price': totalPrice,
            'cart_entries':
                cartEntries, // Keep all original entries for reference
          });

          // Sync productQuantities map with cart data
          final String quantityKey = product.productId?.toString() ??
              product.productName ??
              'product_$productId';

          // CRITICAL FIX: Always update local quantity with cart data to ensure consistency
          productQuantities[quantityKey] = totalQuantity;
          log('📦 Updated local quantity for ${product.productName}: $totalQuantity');

          log('📦 Added cart item: ${product.productName} - Total Quantity: $totalQuantity, Total Price: $totalPrice');
      } else {
          log('Skipping cart item with product_id $productId because product not found.');
        }
      }

      log('🛒 Final cart state: ${fetchedCartItems.length} items');
      for (var item in fetchedCartItems) {
        final product = item['product'] as top_rated.Product;
        log('   - ${product.productName}: ${item['quantity']} units');
      }

      // CRITICAL FIX: Try to improve product names for placeholder products
      await _improveProductNames();

      // CRITICAL FIX: Don't call syncProductQuantitiesWithCart() to avoid overriding local quantities
      // syncProductQuantitiesWithCart();

      safeNotifyListeners();
    } catch (e) {
      log('Error in fetchCartFromApi: $e');
      // Don't clear existing cart data on error to prevent UI issues
    }
  }

  double get fetchedCartTotal {
    double total = 0;
    for (var item in fetchedCartItems) {
      total += (item['total_price'] as double? ?? 0.0);
    }
    return total;
  }

  Future<bool> updateCartItem(
      {required int cartId,
      required top_rated.Product product,
      required int quantity}) async {
    try {
      // CRITICAL FIX: Preserve the current local quantity
      final String quantityKey = product.productId?.toString() ??
          product.productName ??
          'product_${product.productId}';
      final currentLocalQuantity = productQuantities[quantityKey] ?? 0;

      // Use the higher quantity between local and requested
      final finalQuantity =
          quantity > currentLocalQuantity ? quantity : currentLocalQuantity;

      log('🔍 UpdateCartItem - Local quantity: $currentLocalQuantity, Requested: $quantity, Final: $finalQuantity');

    final success = await _repository.updateCartItem(
      cartId: cartId,
      productId: product.productId ?? 0,
        quantity: finalQuantity,
      price: product.price,
    );
    if (success) {
        // Update local data immediately instead of fetching from API
        final cartItemIndex =
            fetchedCartItems.indexWhere((item) => item['id'] == cartId);
        if (cartItemIndex != -1) {
          fetchedCartItems[cartItemIndex]['quantity'] = finalQuantity;
          fetchedCartItems[cartItemIndex]['total_price'] =
              (product.price ?? 0.0) * finalQuantity;
          cart[product] = finalQuantity;

          // CRITICAL FIX: Update local quantities with the final quantity
          productQuantities[quantityKey] = finalQuantity;

          safeNotifyListeners();
        }
    }
    return success;
    } catch (e) {
      log('Error updating cart item: $e');
      return false;
    }
  }

  Future<bool> deleteCartItem({required int cartId}) async {
    if (cartItemDeleteLoading[cartId] == true) {
      log('DeleteCartItem request ignored: delete already in progress for cartId $cartId');
      return false;
    }

    cartItemDeleteLoading[cartId] = true;
    safeNotifyListeners();

    try {
    final success = await _repository.deleteCartItem(cartId: cartId);
    if (success) {
        // Remove from local data immediately instead of fetching from API
        final removedItemIndex =
            fetchedCartItems.indexWhere((item) => item['id'] == cartId);
        if (removedItemIndex != -1) {
          final removedItem = fetchedCartItems[removedItemIndex];
          final product = removedItem['product'] as top_rated.Product;
          fetchedCartItems.removeAt(removedItemIndex);
          cart.remove(product);

          // CRITICAL FIX: Sync local quantities with cart
          if (product.productId != null) {
            final key = product.productId.toString();
            productQuantities[key] = 0; // Set to 0 when removed
          }

          safeNotifyListeners();
        }
    }
    return success;
    } catch (e) {
      log('Error deleting cart item: $e');
      return false;
    } finally {
      cartItemDeleteLoading[cartId] = false;
      safeNotifyListeners();
    }
  }

  /// Fetch a single product by ID and cache it in the lookup map
  Future<top_rated.Product?> fetchAndCacheProduct(int productId) async {
    // Check if already in cache
    if (_allProductsById.containsKey(productId)) {
      return _allProductsById[productId];
    }

    // CRITICAL FIX: Try to find product in loaded products first
    if (_allLoadedProducts.isNotEmpty) {
      log('🔍 Searching for product $productId in loaded products...');
      for (final product in _allLoadedProducts) {
        if (product.productId == productId) {
          _allProductsById[productId] = product;
          log('✅ Found product in loaded data: ${product.productName}');
          return product;
        }
      }
    }

    try {
      log('🔍 Fetching product $productId from API...');
      final product = await _repository.fetchProductById(productId);
      if (product != null) {
        _allProductsById[productId] = product;
        log('✅ Cached product from API: ${product.productName}');

        // CRITICAL FIX: Log the actual product name for debugging
        if (product.productName != null && product.productName!.isNotEmpty) {
          log('✅ Product name found: ${product.productName}');
        } else {
          log('⚠️ Product name is null or empty for product ID: $productId');
        }

        return product;
      }
    } catch (e) {
      log('❌ Error fetching product $productId: $e');
    }

    log('❌ Product $productId not found in cache, loaded data, or API');
    return null;
  }

  /// Get current quantity for a product from local state
  int getCurrentQuantity(top_rated.Product product) {
    final String quantityKey = product.productId?.toString() ??
        product.productName ??
        'product_${product.productId}';
    return productQuantities[quantityKey] ?? 0;
  }

  /// Update local quantity for a product
  void updateLocalQuantity(top_rated.Product product, int quantity) {
    final String quantityKey = product.productId?.toString() ??
        product.productName ??
        'product_${product.productId}';
    productQuantities[quantityKey] = quantity;
    log('📦 Updated local quantity for ${product.productName}: $quantity');
  }

  /// Try to improve product names for placeholder products
  Future<void> _improveProductNames() async {
    try {
      log('🔍 Checking for products with placeholder names...');

      for (int i = 0; i < fetchedCartItems.length; i++) {
        final item = fetchedCartItems[i];
        final product = item['product'] as top_rated.Product;

        // Check if this is a placeholder name or null
        if (product.productName == null ||
            product.productName!.isEmpty ||
            product.productName!.startsWith('منتج غير معروف')) {
          log('⚠️ Found product with placeholder or null name: ${product.productName}');

          // Try to fetch the actual product name
          final actualProduct =
              await fetchAndCacheProduct(product.productId ?? 0);
          if (actualProduct != null &&
              actualProduct.productName != null &&
              actualProduct.productName!.isNotEmpty &&
              !actualProduct.productName!.startsWith('منتج غير معروف')) {
            log('✅ Updated product name: ${actualProduct.productName}');
            // Update the product in the cart item
            fetchedCartItems[i]['product'] = actualProduct;
          } else {
            log('❌ Could not fetch actual product name for product ID: ${product.productId}');
            // CRITICAL FIX: Try to find product in loaded products
            if (_allLoadedProducts.isNotEmpty) {
              for (final loadedProduct in _allLoadedProducts) {
                if (loadedProduct.productId == product.productId) {
                  log('✅ Found product name in loaded data: ${loadedProduct.productName}');
                  // Create new product with actual name
                  final updatedProduct = top_rated.Product(
                    productId: product.productId,
                    productName: loadedProduct.productName,
                    price: product.price,
                    qtyAvailable: product.qtyAvailable,
                    minimumSoldQuantity: product.minimumSoldQuantity,
                    image: product.image,
                    imageUrl: product.imageUrl,
                    categoryName: product.categoryName,
                  );
                  fetchedCartItems[i]['product'] = updatedProduct;
                  break;
                }
              }
            } else {
              // CRITICAL FIX: Try to get product name from API directly
              try {
                final apiProduct =
                    await _repository.fetchProductById(product.productId ?? 0);
                if (apiProduct != null &&
                    apiProduct.productName != null &&
                    apiProduct.productName!.isNotEmpty) {
                  log('✅ Found product name from API: ${apiProduct.productName}');
                  // Create new product with actual name
                  final updatedProduct = top_rated.Product(
                    productId: product.productId,
                    productName: apiProduct.productName,
                    price: product.price,
                    qtyAvailable: product.qtyAvailable,
                    minimumSoldQuantity: product.minimumSoldQuantity,
                    image: product.image,
                    imageUrl: product.imageUrl,
                    categoryName: product.categoryName,
                  );
                  fetchedCartItems[i]['product'] = updatedProduct;
                }
              } catch (e) {
                log('❌ Error fetching product name from API: $e');
              }
            }
          }
        }
      }

      safeNotifyListeners();
    } catch (e) {
      log('❌ Error improving product names: $e');
    }
  }
}
