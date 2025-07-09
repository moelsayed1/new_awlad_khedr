import 'dart:convert';
import 'dart:ui' as UI;

import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/counter_virtecal.dart';
import 'package:awlad_khedr/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

import '../../../data/model/product_model.dart';

class HomeProductItem extends StatefulWidget {
  const HomeProductItem({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<HomeProductItem> {
  ProductModel? productsLista;
bool isProductsLoaded = false ;
  UI.TextDirection direction = UI.TextDirection.rtl;

  String formatPrice(String price) {
    String normalizedPrice = price.replaceAll(',', '.');
    double? parsedPrice = double.tryParse(normalizedPrice);
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(parsedPrice);
  }

  GetAllProducts() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS);
    final response = await http.get(uriToSend , headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      productsLista = ProductModel.fromJson(jsonDecode(response.body));
    }
    // if (products!.errors!.isEmpty && products!.data!.isNotEmpty) {
      setState(() {
        isProductsLoaded = true;
      });

    }
  @override
  void initState() {
    // TODO: implement initState
    GetAllProducts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return
      isProductsLoaded ?
      ListView.separated(
        itemCount: productsLista!.products!.length,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 15,
            ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        reverse: false,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: direction,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]),
                        child: Image.network(
                          productsLista!.products![index].imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/logoPng.png', fit: BoxFit.contain);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Product Information
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productsLista!.products![index].productName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${productsLista!.products![index].minimumSoldQuantity}",
                              style:const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              productsLista!.products![index].price!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                       // CounterVertical( index,product: productsLista!.products![index],),
                      const AddToCartButton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        })
          : const Center ( child : CircularProgressIndicator());
  }
}



