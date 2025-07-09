import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class CustomRating extends StatefulWidget {
  const CustomRating({super.key});

  @override
  State<CustomRating> createState() => _CustomRatingState();
}

class _CustomRatingState extends State<CustomRating> {
  double value = 3.5;
  @override
  Widget build(BuildContext context) {
    return  RatingStars(
      axis: Axis.horizontal,
      value: value,
      onValueChanged: (v) {
        //
        setState(() {
          value = v;
        });
      },
      starCount: 5,
      starSize: 20,
      valueLabelColor: const Color(0xff9b9b9b),
      valueLabelTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
      valueLabelRadius: 10,
      maxValue: 5,
      starSpacing: 2,
      maxValueVisibility: false,
      valueLabelVisibility: false,
      animationDuration: const Duration(milliseconds: 1000),
      valueLabelPadding: const EdgeInsets.symmetric(
          vertical: 1, horizontal: 8),
      valueLabelMargin: const EdgeInsets.only(right: 8),
      starOffColor: const Color(0xffe7e8ea),
      starColor: Colors.yellow,
      angle: 12,
    );
  }
}