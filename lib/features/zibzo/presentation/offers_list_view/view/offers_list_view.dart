import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_loading_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/deal_of_the_day_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/section_title.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/trending_offer_widget.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class OffersListView extends StatelessWidget {
  final HomeResponseEntity product;
  final ProductState productState;

  const OffersListView({
    super.key,
    required this.product,
    required this.productState,
  });

  @override
  Widget build(BuildContext context) {
    AnalyticsService().logScreensView(
      'offer_list_view',
      'OfferListView',
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => context.go(GoRouterPaths.homeScreenRoute),
        ),
        title: Text(
          StringConstant.specialOffers,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: productState is ProductLoading
          ? const CartLoadingWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SectionTitle(
                    title: StringConstant.trendingOffer,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Visibility(
                    visible: product.offerbanner.isNotEmpty,
                    child:
                        TrendingOfferWidget(offerbanner: product.offerbanner),
                  ),
                  SectionTitle(
                    title: StringConstant.dealOfDay,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Visibility(
                    visible: product.offerdeal.isNotEmpty,
                    child: DealOfTheDayWidget(offerDeal: product.offerdeal),
                  ),
                ],
              ),
            ),
    );
  }
}
