import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/payment_view.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/widgets/payment_form.dart';
import 'package:flutter/material.dart';

class OrderDetailsButton extends StatelessWidget {
  const OrderDetailsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
                blueHawai.withOpacity(0.5)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const OrderDetailsPopup();
              },
            );
          },
          child: const Text(
            'تفاصيل',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: baseFont
            ),
          ),
        ),
      ),
    );
  }
}

class OrderDetailsPopup extends StatelessWidget {
  const OrderDetailsPopup({super.key});

  Widget _buildOrderItem(String name, String price, String quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.grey, // Placeholder for image
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'العدد : $quantity',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    'إجمالي سعر الأوردرات',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'EGP1000',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'رقم الطلب #525963',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 2),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildOrderItem('كرتونة شاي', 'EGP500', '2 كرتونة'),
                _buildOrderItem('بيبسي كولا', 'EGP300', '3 كرتونة'),
                _buildOrderItem('كرتونة لبن', 'EGP200', '1 كرتونة'),
                _buildOrderItem('كرتونة لبن', 'EGP200', '1 كرتونة'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PaymentView(products: [], total: 0.0),
                    ),
                  );
                },
                child: const Text(
                  'الدفع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: baseFont
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
