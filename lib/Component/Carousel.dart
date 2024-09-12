import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<Widget> imgList;
  final double screenHeight;
  final double screenWidth;

  const Carousel({
    required this.imgList,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: screenHeight * 0.35,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        viewportFraction: 1.0,
        enlargeCenterPage: true,
      ),
      items: imgList
          .map((item) => Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item,
                ),
              ))
          .toList(),
    );
  }
}
