import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'invoice_provider.dart';

class InvoiceExampleWidget extends StatefulWidget {
  const InvoiceExampleWidget({Key? key}) : super(key: key);

  @override
  State<InvoiceExampleWidget> createState() => _InvoiceExampleWidgetState();
}

class _InvoiceExampleWidgetState extends State<InvoiceExampleWidget> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _transactionIdController = TextEditingController();

  @override
  void dispose() {
    _orderIdController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Invoice Example')),
        body: Consumer<InvoiceProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _orderIdController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Order ID',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: provider.isLoadingOrderDetails
                              ? null
                              : () async {
                                  final id = int.tryParse(_orderIdController.text);
                                  if (id != null) {
                                    await provider.fetchOrderDetails(id);
                                  }
                                },
                          child: provider.isLoadingOrderDetails
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Get Order'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: provider.isLoadingOrderInvoice
                              ? null
                              : () async {
                                  final id = int.tryParse(_orderIdController.text);
                                  if (id != null) {
                                    await provider.fetchOrderInvoice(id);
                                  }
                                },
                          child: provider.isLoadingOrderInvoice
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Get Order Invoice'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _transactionIdController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Transaction ID',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: provider.isLoadingTransactionInvoice
                              ? null
                              : () async {
                                  final id = int.tryParse(_transactionIdController.text);
                                  if (id != null) {
                                    await provider.fetchTransactionInvoice(id);
                                  }
                                },
                          child: provider.isLoadingTransactionInvoice
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Get Transaction Invoice'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (provider.error != null)
                      Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)),
                    if (provider.orderDetails != null)
                      Text('Order: ${provider.orderDetails}'),
                    if (provider.orderInvoice != null)
                      Text('Order Invoice: ${provider.orderInvoice}'),
                    if (provider.transactionInvoice != null)
                      Text('Transaction Invoice: ${provider.transactionInvoice}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 