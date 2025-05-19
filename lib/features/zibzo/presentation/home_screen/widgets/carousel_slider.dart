import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_banner_entity.dart';

class CarouselImageSlider extends StatelessWidget {
  final List<HomeBannerEntity>? homebanner;
  final bool tshowDots;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  CarouselImageSlider({this.homebanner, super.key, this.tshowDots = true});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      SizedBox(
        width: double.infinity,
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            animateToClosest: true,
            scrollDirection: Axis.horizontal,
            viewportFraction: 1.0,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
          items: homebanner?.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CachedNetworkImage(
                    imageUrl: url.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
      tshowDots
          ? Positioned(
              bottom: 5,
              child: Column(
                children: [
                  // Dots Indicator
                  ValueListenableBuilder(
                    valueListenable: _currentIndex,
                    builder: (context, int currentIndex, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(homebanner?.length ?? 0, (index) {
                          return Container(
                            width: currentIndex == index ? 8.0 : 8.0,
                            height: currentIndex == index ? 8.0 : 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ))
          : Container()
    ]);
  }
}
