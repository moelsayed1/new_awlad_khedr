// import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
// import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/category_selector.dart';
// import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/products_by_category.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../constant.dart';
// import '../../../../core/assets.dart';
// import '../../../drawer_slider/presentation/views/side_slider.dart';
//
// class ProductsScreenView extends StatelessWidget {
//   const ProductsScreenView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           actions: const [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'المنتجاتً',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: baseFont),
//               ),
//             )
//           ],
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 0),
//             child: Builder(
//               builder: (context) => Row(
//                 children: [
//                   IconButton(
//                     icon: Image.asset(
//                       AssetsData.back,
//                       height: 45,
//                       width: 45,
//                     ),
//                     onPressed: () {GoRouter.of(context).pop();},
//                   ),
//                   const Text('للرجوع' , style: TextStyle(color: Colors.black,fontSize: 20 , fontFamily: baseFont, fontWeight: FontWeight.w600),),
//                 ],
//               ),
//             ),
//           ),
//           leadingWidth: 130,
//           centerTitle: true,
//           titleSpacing: 0,
//         ),
//         drawer: const CustomDrawer(),
//         body:const SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 SearchWidget(),
//                 SizedBox(height: 15,),
//                 CustomCategorySelector(),
//                 SizedBox(height: 15,),
//                 ProductItem(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/category_selector.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/products_by_category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constant.dart';
import '../../../../core/assets.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';

class ProductsScreenView extends StatefulWidget {
  const ProductsScreenView({super.key});

  @override
  State<ProductsScreenView> createState() => _ProductsScreenViewState();
}

class _ProductsScreenViewState extends State<ProductsScreenView> {
  int selectedCategoryId = 1; // Default category ID

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'المنتجاتً',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont),
              ),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      AssetsData.back,
                      height: 45,
                      width: 45,
                    ),
                    onPressed: () {GoRouter.of(context).pop();},
                  ),
                  const Text('للرجوع' , style: TextStyle(color: Colors.black,fontSize: 20 , fontFamily: baseFont, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
          ),
          leadingWidth: 130,
          centerTitle: true,
          titleSpacing: 0,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Category Selector
                CustomCategorySelector(
                  onCategorySelected: (categoryId) {
                    setState(() {
                      selectedCategoryId = categoryId;
                    });
                  },
                ),
                const SizedBox(height: 15),
                ProductItemByCategory(selectedCategoryId: selectedCategoryId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
