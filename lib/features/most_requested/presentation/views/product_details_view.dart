import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/most_requested_app_bar.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MostRequestedAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductItemCard(
                product: product,
                quantity: 0, // You can integrate with your cart logic if needed
                onQuantityChanged: (q) {},
                onAddToCart: () {},
              ),
              SizedBox(height: 20.h),
              // Add more product details here if needed
            ],
          ),
        ),
      ),
    );
  }
} 