import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_banner_entity.dart';

class TrendingOfferWidget extends StatelessWidget {
  final List<HomeBannerEntity> homebanner;
  const TrendingOfferWidget({super.key, required this.homebanner});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 294,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: homebanner.length,
        itemBuilder: (context, index) {
          final trendingOffers = homebanner[index];
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 6, right: 6),
                height: 227,
                width: 207,
                child: CachedNetworkImage(
                  imageUrl: "http://localhost:4000/${trendingOffers.image}",
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
                      Center(child: const CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Icon(Icons.access_time),
              const SizedBox(
                height: 5,
              ),
              Text(
                StringConstant.endInDays,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
