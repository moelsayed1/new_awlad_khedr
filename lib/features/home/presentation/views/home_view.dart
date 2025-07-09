import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/carousel_slider.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/category_home.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
import 'package:awlad_khedr/features/most_requested/presentation/views/top_rated.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/app_router.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowPopup());
  }

  Future<void> _checkAndShowPopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownPopup = prefs.getBool('hasShownPopup') ?? false;

    if (!hasShownPopup) {
      _showStartupDialog();
      await prefs.setBool('hasShownPopup', true);
    }
  }

  void _showStartupDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Image.asset(
            'assets/images/ads.png',
            width: 316,
            height: 392,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    '🎉  اهلا مرحبا بك',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, fontFamily: baseFont),
                  ),
                  Text(
                    'أبدأ التسوق',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont),
                  ),
                ],
              ),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => IconButton(
                icon: Image.asset(
                  AssetsData.drawerIcon,
                  height: 45,
                  width: 45,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SearchWidget(),
                const SizedBox(
                  height: 15,
                ),
                const CarouselWithIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kCategoriesPage);
                      },
                      child: const Text(
                        "المزيد",
                        style: TextStyle(
                            color: darkOrange,
                            fontSize: 14,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Text(
                      "الأصنـــاف",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                        child: HomeCategory()),],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kMostRequestedPage);
                      },
                      child: const Text(
                        "للمزيد",
                        style: TextStyle(
                            color: darkOrange,
                            fontSize: 14,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Text(
                      "الأكثر طلباً",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                        child: TopRatedItem()),],
                ),
                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}





// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     InkWell(
//       onTap: () {
//         GoRouter.of(context).push(AppRouter.kProductsScreenView);
//       },
//       child: const Text(
//         "للمزيد",
//         style: TextStyle(
//             color: darkOrange,
//             fontSize: 14,
//             fontFamily: baseFont,
//             fontWeight: FontWeight.w700),
//       ),
//     ),
//     const Text(
//       "المنتجات",
//       style: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           fontFamily: baseFont,
//           fontWeight: FontWeight.w700),
//     ),
//   ],
// ),
// const SizedBox(height: 10),
// const HomeProductItem(),