import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kotarica/config/config.dart';

class Carousel extends StatelessWidget {
  final String image;
  final List<String> images;

  const Carousel({
    this.image,
    this.images
  });

  @override
  Widget build(BuildContext context) {
    //debugPrint("images.length : "+images.length.toString());
    return Swiper(
      itemCount: images.length == 0 ? 1 : images.length,
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
            child: Image.network(
              images.length == 0 ? "${Config.IAMGE_URL}/${image}" :
              "${Config.IAMGE_URL}/${images[index]}",
              //height: 280,
              //width: 280,
              //scale: 0.8,
            ));
      },
      viewportFraction: 0.8,
      scale: 0.8,
      pagination: SwiperPagination(),
      control: SwiperControl(),
    );
  }
}
