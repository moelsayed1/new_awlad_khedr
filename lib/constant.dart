import 'package:flutter/material.dart';

const mainColor  = Color(0xffFFE3AF);
const buttonColor  = Color(0xffD9D9D9);
const darkOrange  = Color(0xffFC6E2A);
const deepRed  = Color(0xff591712);
const kBrown  = Color(0xffC29500);
const blueHawai  = Color(0xff63B4FF);
const brownDark  = Color(0xffB58938);

const baseFont = 'GE Dinar One';



class APIConstant {
  static const BASE_URL = "https://erp.khedrsons.com";
  static const REGISTRER_USER = "$BASE_URL/api/user/register";
  static const LOGIN_USER = "$BASE_URL/api/login";
  static const SEND_OTP = "$BASE_URL/api/send-otp";
  static const VERIFY_OTP = "$BASE_URL/api/send-verification-email";
  static const RESET_PASSWORD = "$BASE_URL/api/reset-password";
  static const GET_ALL_PRODUCTS = "$BASE_URL/api/products";
  static const GET_ALL_PRODUCTS_BY_CATEGORY = "$BASE_URL/api/category/products";
  static const GET_TOP_RATED_ITEMS = "$BASE_URL/api/products/totalSold";
  static const GET_BANNERS = "$BASE_URL/api/banners";
  static const GET_ALL_CATEGORIES = "$BASE_URL/api/categories";
  static const GET_ALL_SUBCATEGORIES = "$BASE_URL/api/category/subcategories";
  static const GET_ALL_ORDERS = "$BASE_URL/api/sells/orders";
  static const GET_ALL_TRANSACTIONS = "$BASE_URL/api/sells/transactions";
  static const STORE_SELL = "$BASE_URL/api/sells/store";
  static const GET_ORDER = "$BASE_URL/api/orders"; // Usage: /api/orders/{id}
  static const GET_ORDER_INVOICE = "$BASE_URL/api/order-invoice"; // Usage: /api/order-invoice/{id}
  static const GET_TRANSACTION_INVOICE = "$BASE_URL/api/transaction-invoice"; // Usage: /api/transaction-invoice/{id}
  static const STORE_TO_CART = "$BASE_URL/api/cart";
  static const GET_STORED_CART = "$BASE_URL/api/cart";
  static const STORE_ORDER = "$BASE_URL/api/sells/store";
  static const GET_PRODUCTS_BY_BRAND = "$BASE_URL/api/banner-products"; // Usage: /api/banner-products?brand_id=xxx
  static const UPDATE_CART = "$BASE_URL/api/cart"; // Usage: /api/cart/{id} for update
  static const DELETE_CART = "$BASE_URL/api/cart/delete"; // Usage: /api/cart/delete/{id} for delete
  static const String ORDER_INVOICE = '/api/order-invoice/';
  static const GET_CUSTOMER_MAIN_DATA = "$BASE_URL/api/customer";
  static const UPDATE_USER_DATA = "$BASE_URL/api/update/user";
  static const GET_USER_NOTIFICATIONS = "$BASE_URL/api/get-user-notifications";

}