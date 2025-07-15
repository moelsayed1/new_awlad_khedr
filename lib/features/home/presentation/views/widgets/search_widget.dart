import 'package:flutter/material.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(String)? onCategorySelected;
  const SearchWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onCategorySelected,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<String> searchHistory = [];
  List<String> categories = [];
  bool showSuggestions = false;
  final CategoryRepository _categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSearchHistory();
      await loadCategories();
    });
  }

  Future<void> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('search_history') ?? [];
      if (mounted) {
        setState(() {
          searchHistory = history;
        });
      }
    } catch (e) {
      debugPrint('Error loading search history: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      final fetchedCategories = await _categoryRepository.fetchCategories();
      if (mounted) {
        setState(() {
          categories = fetchedCategories.where((cat) => cat != 'الكل').toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  void _onTap() {
    setState(() {
      showSuggestions = true;
    });
  }

  void _onSubmitted(String query) {
    setState(() {
      showSuggestions = false;
    });
    // If the query is contained in any category name (partial match, case-insensitive), treat it as a category selection
    final matchedCategory = categories.firstWhere(
      (cat) => cat.toLowerCase().contains(query.trim().toLowerCase()),
      orElse: () => '',
    );
    if (matchedCategory.isNotEmpty) {
      widget.onCategorySelected?.call(matchedCategory);
    } else {
      widget.onSubmitted?.call(query);
    }
  }


  void _onCategorySelected(String category) {
    setState(() {
      showSuggestions = false;
    });
    widget.onCategorySelected?.call(category);
  }

  void _onHistoryItemSelected(String query) {
    widget.controller?.text = query;
    _onSubmitted(query);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // This GestureDetector covers the whole area and hides suggestions on tap
        if (showSuggestions)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showSuggestions = false;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                onSubmitted: _onSubmitted,
                onTap: _onTap,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: baseFont,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'أبحث عن منتجاتك أو اختر صنف',
                  hintStyle: TextStyle(
                    fontFamily: baseFont,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            if (showSuggestions &&
                (searchHistory.isNotEmpty || categories.isNotEmpty))
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search History Section
                    if (searchHistory.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'البحث السابق',
                              style: TextStyle(
                                fontFamily: baseFont,
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('search_history');
                                if (mounted) {
                                  setState(() {
                                    searchHistory.clear();
                                  });
                                }
                              },
                              child: Icon(
                                Icons.clear,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...searchHistory.take(3).map((query) => ListTile(
                            dense: true,
                            title: Text(
                              query,
                              style: TextStyle(
                                fontFamily: baseFont,
                                fontSize: 14.sp, // Increased for clarity
                                color: Colors.black,
                              ),
                            ),
                            leading: const Icon(Icons.history, size: 16),
                            onTap: () => _onHistoryItemSelected(query),
                          )),
                    ],
                    // Categories Section
                    if (categories.isNotEmpty) ...[
                      if (searchHistory.isNotEmpty) const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'الأصناف',
                          style: TextStyle(
                            fontFamily: baseFont,
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ...categories.take(6).map((category) => ListTile(
                            dense: true,
                            title: Text(
                              category,
                              style: TextStyle(
                                fontFamily: baseFont,
                                color: Colors.black,
                                fontSize: 14.sp, // Increased for clarity
                              ),
                            ),
                            leading: const Icon(Icons.category, size: 16),
                            onTap: () => _onCategorySelected(category),
                          )),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
