import 'dart:convert';
import 'dart:developer';
import 'package:awlad_khedr/features/home/data/model/carousel_model.dart'; // Assuming BannersModel and Datum are here
import 'package:carousel_slider/carousel_slider.dart'; // This is the correct package import
import 'package:flutter/material.dart'; // <--- FIX: Hide Flutter's CarouselController
import 'package:http/http.dart' as http;
import '../../../../../constant.dart'; // For APIConstant.GET_BANNERS
import '../../../../../main.dart'; // For authToken
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive units

class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  BannersModel? bannersModel;
  bool isBannerLoaded = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _getAllBanners();
  }

  Future<void> _getAllBanners() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_BANNERS);
    try {
      final response = await http.get(uriToSend, headers: {"Authorization": "Bearer $authToken"});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        bannersModel = BannersModel.fromJson(responseBody);
        log('Banners API Response: ${response.body}');

        if (bannersModel != null && bannersModel!.data.isNotEmpty) {
          setState(() {
            isBannerLoaded = true;
            hasError = false;
          });
        } else {
          log('Banners data is empty or null.');
          setState(() {
            isBannerLoaded = true;
            hasError = true;
          });
        }
      } else {
        log('Failed to load banners: ${response.statusCode}, Body: ${response.body}');
        setState(() {
          isBannerLoaded = true;
          hasError = true;
        });
      }
    } catch (e) {
      log('Error fetching banners: $e');
      setState(() {
        isBannerLoaded = true;
        hasError = true;
      });
    }
  }

  int _current = 0;
  // <--- FIX: Use CarouselSliderController from carousel_slider package explicitly
  final CarouselSliderController _controller = CarouselSliderController();

  List<Datum> _generateDummyBanners() {
    return List.generate(3, (index) => Datum(
      id: index,
      title: 'Dummy Banner $index',
      image: 'https://picsum.photos/seed/banner$index/800/400',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/seed/banner$index/800/400',
      // Add other Datum fields if needed
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!isBannerLoaded) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Use dummy banners if error or no data
    final List<Datum> bannersToShow = (hasError || bannersModel == null || bannersModel!.data.isEmpty)
        ? _generateDummyBanners()
        : bannersModel!.data;

    return Column(
      children: [
        InkWell(
          onTap: () {
            // GoRouter.of(context).push(AppRouter.kProductCarouselView);
          },
          child: CarouselSlider(
            items: bannersToShow.map((Datum item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                        ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.broken_image, size: 50.sp, color: Colors.grey),
                        );
                      },
                    )
                        : Center(
                      child: Icon(Icons.image_not_supported, size: 50.sp, color: Colors.grey),
                    ),
                  );
                },
              );
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
              height: 180.h,
              viewportFraction: 0.9,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.easeOutSine,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannersToShow.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: _current == entry.key ? 24.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}