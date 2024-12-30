import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_banner_entity.dart';

class DealOfTheDayWidget extends StatelessWidget {
  final List<HomeBannerEntity> homebanner;
  const DealOfTheDayWidget({super.key, required this.homebanner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        runSpacing: 15,
        children: homebanner.map((trendingOffers) {
          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 194,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: CachedNetworkImage(
                    imageUrl: trendingOffers.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 5),
                const Icon(Icons.access_time),
                const SizedBox(height: 5),
                Text(
                  StringConstant.endInDays,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
