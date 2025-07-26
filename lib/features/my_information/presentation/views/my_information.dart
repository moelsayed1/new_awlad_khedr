import 'dart:developer';

import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';
import 'package:flutter/material.dart';
import '../../../../constant.dart';
import '../../../../core/assets.dart';
import '../../../../core/custom_button.dart';
import 'my_information_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyInformation extends StatefulWidget {
  const MyInformation({super.key});

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  CustomerInfo? _customerInfo;
  bool _loading = true;
  File? _localProfileImage;

  // Controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();

  // FocusNodes for each field
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _supplierNameFocus = FocusNode();

  // Editing state for each field
  bool _isEditingName = false;
  bool _isEditingPhone = false;
  bool _isEditingEmail = false;
  bool _isEditingAddress = false;
  bool _isEditingSupplierName = false;

  // Track if any field has changed
  bool get _hasUnsavedChanges {
    if (_customerInfo == null) return false;
    return _nameController.text != _customerInfo!.name ||
        _phoneController.text != (_customerInfo!.phone ?? '') ||
        _emailController.text != _customerInfo!.email ||
        _addressController.text != _customerInfo!.addressLine1 ||
        _supplierNameController.text != _customerInfo!.supplierBusinessName;
  }

  @override
  void initState() {
    super.initState();
    _fetchCustomerInfo();
  }

  Future<void> _fetchCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final info = await MyInformationLogic.fetchCustomerInfo(token);
      setState(() {
        _customerInfo = info;
        _loading = false;
        if (info != null) {
          _nameController.text = info.name;
          _phoneController.text = info.phone ?? '';
          _emailController.text = info.email;
          _addressController.text = info.addressLine1;
          _supplierNameController.text = info.supplierBusinessName;
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || _customerInfo == null) return;
    setState(() {
      _loading = true;
    });

    final success = await MyInformationLogic.updateUserDataWithPhoto(
      token,
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      addressLine1: _addressController.text,
      supplierBusinessName: _supplierNameController.text,
      profilePhoto: _localProfileImage,
    );
    if (success) {
      await _fetchCustomerInfo();
      setState(() {
        _isEditingName = false;
        _isEditingPhone = false;
        _isEditingEmail = false;
        _isEditingAddress = false;
        _isEditingSupplierName = false;
        _localProfileImage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم حفظ التعديلات بنجاح',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 2),
          elevation: 4,
        ),
      );
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في حفظ التعديلات')),
      );
    }
  }

  Future<void> _onExit() async {
    if (_hasUnsavedChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الخروج'),
          content:
              const Text('لديك تعديلات غير محفوظة. هل تريد حفظها قبل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('خروج بدون حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      );
      if (result == true) {
        await _saveChanges();
      }
    }
    Navigator.of(context).pop();
  }

  void _onEditProfilePhoto() async {
    log('Edit icon tapped'); // Debug print
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _localProfileImage = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected image: \'${pickedFile.path}\'')),
      );
      // TODO: Upload image to backend and update profilePhoto URL
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => IconButton(
                icon: Image.asset(
                  AssetsData.drawerIcon,
                  height: 45,
                  width: 45,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'بيانات الاساسية',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont),
              ),
            )
          ],
        ),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _customerInfo == null
                  ? const Center(child: Text('تعذر تحميل البيانات'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 100.w, // diameter of CircleAvatar
                              height: 100.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _loading
                                      ? CircleAvatar(
                                          radius: 50.w,
                                          backgroundColor: Colors.grey,
                                          child: CircularProgressIndicator(color: Colors.white),
                                        )
                                      : (_localProfileImage != null)
                                          ? CircleAvatar(
                                              radius: 50.w,
                                              backgroundColor: Colors.grey.shade300,
                                              backgroundImage: FileImage(_localProfileImage!),
                                            )
                                          : (_customerInfo?.profilePhoto != null && _customerInfo!.profilePhoto!.isNotEmpty)
                                              ? CircleAvatar(
                                                  radius: 50.w,
                                                  backgroundColor: Colors.grey.shade300,
                                                  backgroundImage: NetworkImage(_customerInfo!.profilePhoto!),
                                                )
                                              : CircleAvatar(
                                                  radius: 50.w,
                                                  backgroundColor: Colors.grey,
                                                  child: Icon(Icons.person, size: 50.w, color: Colors.white),
                                                ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _onEditProfilePhoto,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: darkOrange,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.w),
                                        ),
                                        padding: EdgeInsets.all(6.w),
                                        child: Icon(Icons.edit, color: Colors.white, size: 20.w),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'الاسم',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            controller: _nameController,
                            readOnly: !_isEditingName,
                            focusNode: _nameFocus,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEditingName = true;
                                });
                                _nameFocus.requestFocus();
                              },
                            ),
                            radius: 10,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'رقم التليفون',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            controller: _phoneController,
                            readOnly: !_isEditingPhone,
                            focusNode: _phoneFocus,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEditingPhone = true;
                                });
                                _phoneFocus.requestFocus();
                              },
                            ),
                            radius: 10,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'البريد الالكتروني',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            controller: _emailController,
                            readOnly: !_isEditingEmail,
                            focusNode: _emailFocus,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEditingEmail = true;
                                });
                                _emailFocus.requestFocus();
                              },
                            ),
                            radius: 10,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'عنوان الماركت',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            controller: _addressController,
                            readOnly: !_isEditingAddress,
                            focusNode: _addressFocus,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEditingAddress = true;
                                });
                                _addressFocus.requestFocus();
                              },
                            ),
                            radius: 10,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'اسم الماركت',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            controller: _supplierNameController,
                            readOnly: !_isEditingSupplierName,
                            focusNode: _supplierNameFocus,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEditingSupplierName = true;
                                });
                                _supplierNameFocus.requestFocus();
                              },
                            ),
                            radius: 10,
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: CustomButton(
                              text: 'حفظ التعديلات',
                              textColor: Colors.white,
                              color: darkOrange,
                              fontSize: 18,
                              width: 154,
                              height: 40,
                              onTap: _saveChanges,
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
