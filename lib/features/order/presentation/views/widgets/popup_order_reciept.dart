import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/order/data/model/order_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonReceipt extends StatelessWidget {
  final Order order;
  const CustomButtonReceipt({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 32.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(mainColor),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ReceiptOrderDetails(order: order);
              },
            );
          },
          child: const Text(
            'فاتورة الطلب',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: baseFont),
          ),
        ),
      ),
    );
  }
}

class ReceiptOrderDetails extends StatelessWidget {
  final Order order;
  const ReceiptOrderDetails({super.key, required this.order});

  Widget _buildOrderItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8 , vertical:4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Column(
              children: [
                Text(
                  'فاتورة  الطلب ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Divider(thickness: 2,color: darkOrange,indent: 100,endIndent: 100,),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.total} ج,م',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'اجمالي الفاتورة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...order.products.map((product) => _buildOrderItem(
              product.productName ?? '',
              '${product.price} ج,م',
            )),
            _buildOrderItem('طريقة الدفع', 'دفع الاجل'),
          ],
        ),
      ),
    );
  }
}
