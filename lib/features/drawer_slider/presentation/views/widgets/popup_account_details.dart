import 'dart:ui' as ui;
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/invoice/data/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class OrderDetailsButton extends StatelessWidget {
  const OrderDetailsButton({super.key, required this.transaction});
  final Map<String, dynamic> transaction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(blueHawai.withValues(alpha: 0.5)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => ChangeNotifierProvider(
                create: (_) => InvoiceProvider(),
                builder: (providerContext, child) => Consumer<InvoiceProvider>(
                  builder: (context, invoiceProvider, _) {
                    return OrderDetailsPopup(transaction: transaction);
                  },
                ),
              ),
            );
          },
          child: const Text(
            'تفاصيل',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: baseFont),
          ),
        ),
      ),
    );
  }
}

class OrderDetailsPopup extends StatefulWidget {
  const OrderDetailsPopup({
    super.key,
    this.transactionId,
    this.transaction,
  }) : assert(transactionId != null || transaction != null,
            'Either transactionId or transaction must be provided');

  final int? transactionId;
  final Map<String, dynamic>? transaction;

  @override
  State<OrderDetailsPopup> createState() => _OrderDetailsPopupState();
}

class _OrderDetailsPopupState extends State<OrderDetailsPopup> {
  @override
  void initState() {
    super.initState();
    // Fetch data only if the full transaction object isn't provided
    if (widget.transaction == null && widget.transactionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<InvoiceProvider>(context, listen: false)
            .fetchTransactionInvoice(widget.transactionId!);
      });
    }
  }

  String _formatPrice(String priceString) {
    final price = double.tryParse(priceString);
    if (price == null) {
      return priceString; // Return original string if parsing fails
    }
    // If the price is a whole number, format as an integer
    if (price == price.truncate()) {
      return price.toInt().toString();
    }
    // Otherwise, return as a double (or with specific formatting)
    return price.toStringAsFixed(2); // e.g., show 2 decimal places
  }

  String splitAfterTwoWords(String text) {
    final words = text.split(' ');
    if (words.length <= 2) return text;
    return '${words.take(2).join(' ')}\n${words.skip(2).join(' ')}';
  }


  @override
  Widget build(BuildContext context) {
    // If the transaction data is already available, build the UI directly
    if (widget.transaction != null) {
      return _buildContent(context, invoiceDetails: widget.transaction!);
    }

    // Otherwise, use the Consumer to wait for the fetched data
    return Consumer<InvoiceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingTransactionInvoice) {
          return const Dialog(
              backgroundColor: Colors.transparent,
              child: Center(child: CircularProgressIndicator()));
        }

        if (provider.error != null) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(provider.error!),
            ),
          );
        }

        final invoiceDetails = provider.transactionInvoice;
        if (invoiceDetails == null) {
          return const Dialog(child: Center(child: Text('No details found.')));
        }

        return _buildContent(context, invoiceDetails: invoiceDetails);
      },
    );
  }

  Widget _buildContent(BuildContext context,
      {required Map<String, dynamic> invoiceDetails}) {
    final totalPrice = invoiceDetails['final_total']?.toString() ?? '0';
    final invoiceNo = invoiceDetails['invoice_no']?.toString() ??
        invoiceDetails['invoice_number']?.toString() ??
        '-';
    final items = (invoiceDetails['sell_lines'] as List<dynamic>?) ?? [];

    // Group items by product id (fallback to name if id not available)
    final Map<String, Map<String, dynamic>> grouped = {};
    for (var item in items) {
      final product = item['product'] ?? {};
      final productId =
          product['id']?.toString() ?? product['name']?.toString() ?? 'unknown';
      if (grouped.containsKey(productId)) {
        // Sum the quantity
        final prevQty =
            double.tryParse(grouped[productId]!['quantity'].toString()) ?? 0;
        final newQty =
            double.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
        grouped[productId]!['quantity'] = (prevQty + newQty).toString();
      } else {
        // Clone the item for grouping
        grouped[productId] = Map<String, dynamic>.from(item);
      }
    }
    final groupedItems = grouped.values.toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  width: double.infinity,
                  color: darkOrange,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_back,
                                  size: 20, color: Colors.black),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'اجمالي سعر الاوردرات',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: baseFont),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'EGP ${_formatPrice(totalPrice)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Order number
                      Center(
                        child: Column(
                          children: [
                            Text('رقم الطلب #$invoiceNo',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 3, width: 20, color: Colors.grey),
                                const SizedBox(width: 4),
                                Container(
                                    height: 3, width: 20, color: Colors.grey),
                                const SizedBox(width: 4),
                                Container(
                                    height: 3, width: 40, color: darkOrange),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Details title
                      const Text('تفاصيل الاوردر',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: baseFont)),
                      const SizedBox(height: 16),
                      // Table-like structure with three columns
                      _buildOrderItemsTable(groupedItems),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsTable(List<Map<String, dynamic>> groupedItems) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Product Name Column Header - Right Aligned
                  Expanded(
                    flex: 3,
                    child: Text(
                      'اسم المنتج',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: baseFont,
                      ),
                      textAlign: TextAlign.start, // Right align the header
                    ),
                  ),
                  // Price Column Header
                  Expanded(
                    flex: 2,
                    child: Text(
                      'السعر',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: baseFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Quantity Column Header
                  Expanded(
                    flex: 1,
                    child: Text(
                      'الكمية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: baseFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Table Data Rows
            ...groupedItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final product = item['product'] ?? {};
              final productName = product['name']?.toString() ?? 'N/A';
              final quantity = item['quantity']?.toString() ?? '0';
              final price = item['unit_price']?.toString() ?? '0';

              // Format quantity: remove .0 if integer
              String formattedQuantity;
              final doubleQty = double.tryParse(quantity);
              if (doubleQty != null &&
                  doubleQty == doubleQty.truncateToDouble()) {
                formattedQuantity = doubleQty.toInt().toString();
              } else {
                formattedQuantity = quantity;
              }

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index < groupedItems.length - 1
                          ? Colors.grey[200]!
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    children: [
                      // Product Name Column - Right Aligned
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            splitAfterTwoWords(productName),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: baseFont,
                            ),
                            textAlign: TextAlign
                                .start, // Right align the product names
                          ),
                        ),
                      ),
                      // Price Column - Fixed layout to keep currency on same line
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  price,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: darkOrange,
                                    fontFamily: baseFont,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'ج.م',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontFamily: baseFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Quantity Column
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Text(
                            formattedQuantity,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: baseFont,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
