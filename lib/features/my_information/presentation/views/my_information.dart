import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../constant.dart';
import '../../../../core/assets.dart';
import '../../../../core/custom_button.dart';

class MyInformation extends StatelessWidget {
  const MyInformation({super.key});
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
              child: Text('بيانات الاساسية' , style: TextStyle(fontSize: 20,color: Colors.black,  fontWeight: FontWeight.bold, fontFamily: baseFont),),
            )
          ],
        ),
        drawer: const CustomDrawer(),
        body:  const Padding(
          padding:  EdgeInsets.all(18.0),
          child:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('الاسم',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8,),
                CustomTextField(
                  hintText: 'محمد عبدالعالي',
                 prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                SizedBox(height: 16,),
                Text('رقم التليفون',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                SizedBox(height: 8,),
                CustomTextField(
                  hintText: '+20 010 16 087 103',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                SizedBox(height: 16,),
                Text('البريد الالكتروني',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                SizedBox(height: 8,),
                CustomTextField(
                  hintText: 'ashfaksayem@gmail.com',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                SizedBox(height: 16,),
                Text('عنوان الماركت',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                SizedBox(height: 8,),
                CustomTextField(
                  hintText: '------------',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                SizedBox(height: 16,),
                Text('اسم الماركت',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                SizedBox(height: 8,),
                CustomTextField(
                  hintText: '-----------------',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: CustomButton(
                    text:'حفظ التعديلات' ,
                    textColor: Colors.white ,
                    color: darkOrange,
                    fontSize: 18,
                    width: 154,
                    height:40 ,
                  ),
                ),
                SizedBox(height: 8,),
                Center(
                  child: CustomButton(
                    text:'خروج' ,
                    textColor: Colors.black ,
                    color: buttonColor,
                    fontSize: 18,
                    width: 154,
                    height:40 ,
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
