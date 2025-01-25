import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/offer_banner_entity.dart';

class TrendingOfferWidget extends StatelessWidget {
  final List<OfferBannerEntity> offerbanner;
  const TrendingOfferWidget({super.key, required this.offerbanner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        runSpacing: 15,
        children: offerbanner.map((offerBanners) {
          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 194,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: CachedNetworkImage(
                    imageUrl: offerBanners.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
