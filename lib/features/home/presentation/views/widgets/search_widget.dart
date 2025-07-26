import 'package:flutter/material.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool showSuggestions = false;
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSearchHistory();
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

  void _onTap() {
    setState(() {
      showSuggestions = true;
    });
  }

  void _onChanged(String value) {
    setState(() {
      currentQuery = value;
      showSuggestions = true;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _onSubmitted(String query) async {
    setState(() {
      showSuggestions = false;
      currentQuery = query;
    });
    // Save to search history
    if (query.trim().isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      List<String> updatedHistory = List.from(searchHistory);
      updatedHistory.remove(query);
      updatedHistory.insert(0, query);
      if (updatedHistory.length > 10) {
        updatedHistory = updatedHistory.sublist(0, 10);
      }
      await prefs.setStringList('search_history', updatedHistory);
      setState(() {
        searchHistory = updatedHistory;
      });
    }
    widget.onSubmitted?.call(query);
  }

  void _onHistoryItemSelected(String query) {
    widget.controller?.text = query;
    _onSubmitted(query);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                onChanged: _onChanged,
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
                  hintText: 'أبحث عن منتجاتك',
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
            if (showSuggestions && (searchHistory.isNotEmpty || currentQuery.trim().isNotEmpty))
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
                    // Show current query as a suggestion
                    if (currentQuery.trim().isNotEmpty)
                      ListTile(
                        dense: true,
                        title: Text(
                          currentQuery,
                          style: TextStyle(
                            fontFamily: baseFont,
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                        leading: const Icon(Icons.search, size: 16),
                        onTap: () => _onSubmitted(currentQuery),
                      ),
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
                      ...searchHistory
                          .where((q) => q != currentQuery)
                          .take(3)
                          .map((query) => ListTile(
                                dense: true,
                                title: Text(
                                  query,
                                  style: TextStyle(
                                    fontFamily: baseFont,
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                leading: const Icon(Icons.history, size: 16),
                                onTap: () => _onHistoryItemSelected(query),
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
