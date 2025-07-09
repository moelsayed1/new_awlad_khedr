import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';

class Order {
  final String id;
  final DateTime date;
  final List<Product> products;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.date,
    required this.products,
    required this.total,
    required this.status,
  });
}
