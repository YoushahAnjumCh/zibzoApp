import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/offer_deal_entity.dart';

class DealOfTheDayWidget extends StatelessWidget {
  final List<OfferDealEntity> offerDeal;

  const DealOfTheDayWidget({super.key, required this.offerDeal});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: offerDeal.map((dealofDays) {
          final itemWidth = (screenWidth - 30) / 2;
          return SizedBox(
            width: itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(dealofDays.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dealofDays.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  textAlign: TextAlign.center,
                  dealofDays.offer ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
