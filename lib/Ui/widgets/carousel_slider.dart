import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Api/models/product_models.dart' as api_models;

class CarouselWithIndicator extends StatefulWidget {
  final List<api_models.Banner> banners;

  const CarouselWithIndicator({
    super.key,
    required this.banners,
  });

  @override
  State<CarouselWithIndicator> createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  List<api_models.Banner> _generateDummyBanners() {
    return List.generate(
        3,
        (index) => api_models.Banner(
              id: index,
              title: 'Dummy Banner $index',
              image: 'https://picsum.photos/seed/banner$index/800/400',
              created_at: DateTime.now().toString(),
              updated_at: DateTime.now().toString(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    // Use dummy banners if no data
    final List<api_models.Banner> bannersToShow =
        widget.banners.isEmpty ? _generateDummyBanners() : widget.banners;

    return Column(
      children: [
        InkWell(
          onTap: () {
            // Navigate to product carousel view if needed
          },
          child: CarouselSlider(
            items: bannersToShow.map((api_models.Banner item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: (item.image != null && item.image!.isNotEmpty)
                        ? Image.network(
                            item.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50.sp,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50.sp,
                              color: Colors.grey,
                            ),
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
              onTap: () => _controller.jumpToPage(entry.key),
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
