class StoreSellResponse {
  final bool success;
  final String message;
  final Transaction transaction;

  StoreSellResponse({
    required this.success,
    required this.message,
    required this.transaction,
  });

  factory StoreSellResponse.fromJson(Map<String, dynamic> json) {
    return StoreSellResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      transaction: Transaction.fromJson(json['transaction'] ?? {}),
    );
  }
}

class Transaction {
  final int? carId;
  final int? businessId;
  final int? locationId;
  final String? type;
  final String? status;
  final dynamic subStatus;
  final int? contactId;
  final dynamic customerGroupId;
  final String? invoiceNo;
  final String? refNo;
  final dynamic source;
  final num? totalBeforeTax;
  final String? transactionDate;
  final dynamic taxId;
  final String? discountType;
  final num? discountAmount;
  final num? taxAmount;
  final num? finalTotal;
  final String? additionalNotes;
  final String? staffNote;
  final int? createdBy;
  final String? document;
  final dynamic customField1;
  final dynamic customField2;
  final dynamic customField3;
  final dynamic customField4;
  final int? isDirectSale;
  final dynamic commissionAgent;
  final int? isQuotation;
  final dynamic shippingDetails;
  final dynamic shippingAddress;
  final dynamic shippingStatus;
  final dynamic deliveredTo;
  final num? shippingCharges;
  final dynamic shippingCustomField1;
  final dynamic shippingCustomField2;
  final dynamic shippingCustomField3;
  final dynamic shippingCustomField4;
  final dynamic shippingCustomField5;
  final num? exchangeRate;
  final dynamic sellingPriceGroupId;
  final dynamic payTermNumber;
  final dynamic payTermType;
  final int? isSuspend;
  final int? isRecurring;
  final int? recurInterval;
  final dynamic recurIntervalType;
  final dynamic subscriptionRepeatOn;
  final dynamic subscriptionNo;
  final int? recurRepetitions;
  final dynamic orderAddresses;
  final dynamic subType;
  final num? rpEarned;
  final num? rpRedeemed;
  final num? rpRedeemedAmount;
  final int? isCreatedFromApi;
  final dynamic typesOfServiceId;
  final num? packingCharge;
  final dynamic packingChargeType;
  final dynamic serviceCustomField1;
  final dynamic serviceCustomField2;
  final dynamic serviceCustomField3;
  final dynamic serviceCustomField4;
  final dynamic serviceCustomField5;
  final dynamic serviceCustomField6;
  final num? roundOffAmount;
  final dynamic importBatch;
  final dynamic importTime;
  final dynamic resTableId;
  final dynamic resWaiterId;
  final dynamic salesOrderIds;
  final dynamic preferPaymentMethod;
  final dynamic preferPaymentAccount;
  final int? isExport;
  final dynamic exportCustomFieldsInfo;
  final num? additionalExpenseValue1;
  final num? additionalExpenseValue2;
  final num? additionalExpenseValue3;
  final num? additionalExpenseValue4;
  final dynamic additionalExpenseKey1;
  final dynamic additionalExpenseKey2;
  final dynamic additionalExpenseKey3;
  final dynamic additionalExpenseKey4;
  final String? updatedAt;
  final String? createdAt;
  final int? id;
  final String? paymentStatus;
  final dynamic repairCompletedOn;
  final dynamic repairDueDate;
  final List<dynamic> sellLines;

  Transaction({
    this.carId,
    this.businessId,
    this.locationId,
    this.type,
    this.status,
    this.subStatus,
    this.contactId,
    this.customerGroupId,
    this.invoiceNo,
    this.refNo,
    this.source,
    this.totalBeforeTax,
    this.transactionDate,
    this.taxId,
    this.discountType,
    this.discountAmount,
    this.taxAmount,
    this.finalTotal,
    this.additionalNotes,
    this.staffNote,
    this.createdBy,
    this.document,
    this.customField1,
    this.customField2,
    this.customField3,
    this.customField4,
    this.isDirectSale,
    this.commissionAgent,
    this.isQuotation,
    this.shippingDetails,
    this.shippingAddress,
    this.shippingStatus,
    this.deliveredTo,
    this.shippingCharges,
    this.shippingCustomField1,
    this.shippingCustomField2,
    this.shippingCustomField3,
    this.shippingCustomField4,
    this.shippingCustomField5,
    this.exchangeRate,
    this.sellingPriceGroupId,
    this.payTermNumber,
    this.payTermType,
    this.isSuspend,
    this.isRecurring,
    this.recurInterval,
    this.recurIntervalType,
    this.subscriptionRepeatOn,
    this.subscriptionNo,
    this.recurRepetitions,
    this.orderAddresses,
    this.subType,
    this.rpEarned,
    this.rpRedeemed,
    this.rpRedeemedAmount,
    this.isCreatedFromApi,
    this.typesOfServiceId,
    this.packingCharge,
    this.packingChargeType,
    this.serviceCustomField1,
    this.serviceCustomField2,
    this.serviceCustomField3,
    this.serviceCustomField4,
    this.serviceCustomField5,
    this.serviceCustomField6,
    this.roundOffAmount,
    this.importBatch,
    this.importTime,
    this.resTableId,
    this.resWaiterId,
    this.salesOrderIds,
    this.preferPaymentMethod,
    this.preferPaymentAccount,
    this.isExport,
    this.exportCustomFieldsInfo,
    this.additionalExpenseValue1,
    this.additionalExpenseValue2,
    this.additionalExpenseValue3,
    this.additionalExpenseValue4,
    this.additionalExpenseKey1,
    this.additionalExpenseKey2,
    this.additionalExpenseKey3,
    this.additionalExpenseKey4,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.paymentStatus,
    this.repairCompletedOn,
    this.repairDueDate,
    this.sellLines = const [],
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      carId: json['car_id'],
      businessId: json['business_id'],
      locationId: json['location_id'],
      type: json['type'],
      status: json['status'],
      subStatus: json['sub_status'],
      contactId: json['contact_id'],
      customerGroupId: json['customer_group_id'],
      invoiceNo: json['invoice_no'],
      refNo: json['ref_no'],
      source: json['source'],
      totalBeforeTax: json['total_before_tax'],
      transactionDate: json['transaction_date'],
      taxId: json['tax_id'],
      discountType: json['discount_type'],
      discountAmount: json['discount_amount'],
      taxAmount: json['tax_amount'],
      finalTotal: json['final_total'],
      additionalNotes: json['additional_notes'],
      staffNote: json['staff_note'],
      createdBy: json['created_by'],
      document: json['document'],
      customField1: json['custom_field_1'],
      customField2: json['custom_field_2'],
      customField3: json['custom_field_3'],
      customField4: json['custom_field_4'],
      isDirectSale: json['is_direct_sale'],
      commissionAgent: json['commission_agent'],
      isQuotation: json['is_quotation'],
      shippingDetails: json['shipping_details'],
      shippingAddress: json['shipping_address'],
      shippingStatus: json['shipping_status'],
      deliveredTo: json['delivered_to'],
      shippingCharges: json['shipping_charges'],
      shippingCustomField1: json['shipping_custom_field_1'],
      shippingCustomField2: json['shipping_custom_field_2'],
      shippingCustomField3: json['shipping_custom_field_3'],
      shippingCustomField4: json['shipping_custom_field_4'],
      shippingCustomField5: json['shipping_custom_field_5'],
      exchangeRate: json['exchange_rate'],
      sellingPriceGroupId: json['selling_price_group_id'],
      payTermNumber: json['pay_term_number'],
      payTermType: json['pay_term_type'],
      isSuspend: json['is_suspend'],
      isRecurring: json['is_recurring'],
      recurInterval: json['recur_interval'],
      recurIntervalType: json['recur_interval_type'],
      subscriptionRepeatOn: json['subscription_repeat_on'],
      subscriptionNo: json['subscription_no'],
      recurRepetitions: json['recur_repetitions'],
      orderAddresses: json['order_addresses'],
      subType: json['sub_type'],
      rpEarned: json['rp_earned'],
      rpRedeemed: json['rp_redeemed'],
      rpRedeemedAmount: json['rp_redeemed_amount'],
      isCreatedFromApi: json['is_created_from_api'],
      typesOfServiceId: json['types_of_service_id'],
      packingCharge: json['packing_charge'],
      packingChargeType: json['packing_charge_type'],
      serviceCustomField1: json['service_custom_field_1'],
      serviceCustomField2: json['service_custom_field_2'],
      serviceCustomField3: json['service_custom_field_3'],
      serviceCustomField4: json['service_custom_field_4'],
      serviceCustomField5: json['service_custom_field_5'],
      serviceCustomField6: json['service_custom_field_6'],
      roundOffAmount: json['round_off_amount'],
      importBatch: json['import_batch'],
      importTime: json['import_time'],
      resTableId: json['res_table_id'],
      resWaiterId: json['res_waiter_id'],
      salesOrderIds: json['sales_order_ids'],
      preferPaymentMethod: json['prefer_payment_method'],
      preferPaymentAccount: json['prefer_payment_account'],
      isExport: json['is_export'],
      exportCustomFieldsInfo: json['export_custom_fields_info'],
      additionalExpenseValue1: json['additional_expense_value_1'],
      additionalExpenseValue2: json['additional_expense_value_2'],
      additionalExpenseValue3: json['additional_expense_value_3'],
      additionalExpenseValue4: json['additional_expense_value_4'],
      additionalExpenseKey1: json['additional_expense_key_1'],
      additionalExpenseKey2: json['additional_expense_key_2'],
      additionalExpenseKey3: json['additional_expense_key_3'],
      additionalExpenseKey4: json['additional_expense_key_4'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      paymentStatus: json['payment_status'],
      repairCompletedOn: json['repair_completed_on'],
      repairDueDate: json['repair_due_date'],
      sellLines: json['sell_lines'] ?? [],
    );
  }
} 