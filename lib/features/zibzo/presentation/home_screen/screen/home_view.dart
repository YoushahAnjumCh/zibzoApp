import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/carousel_slider.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/category_items.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/custom_appbar_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/deal_of_the_day_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/product_card_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/section_title.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/trending_offer_widget.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AnalyticsService().logScreensView(
      'home_screen',
      'HomeScreen',
    );

    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: _buildLogoutButton(context),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFail) {
            EasyLoading.showError(state.errorMessage);
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _fetchCartCountAndStore(
                    context, state.product.cartProductCount);
              });
              return HomeContent(product: state.product);
            } else {
              return const Center(child: Text(StringConstant.somethingWrong));
            }
          },
        ),
      ),
    );
  }

  _fetchCartCountAndStore(BuildContext context, int? cartCountAPI) async {
    int cartCount =
        Provider.of<CartCountProvider>(context, listen: false).cartCount;
    if (cartCountAPI != null && cartCountAPI >= cartCount) {
      Provider.of<CartCountProvider>(context, listen: false).saveCartCount(
        cartCountAPI,
      );
      return;
    } else {
      Provider.of<CartCountProvider>(context, listen: false).saveCartCount(
        cartCount,
      );
      return;
    }
  }

  Widget _buildLogoutButton(BuildContext context) {
    return BlocBuilder<SharedPreferencesCubit, AuthState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            AnalyticsService().logLogout();
            context.read<SharedPreferencesCubit>().logout("token");
            context.go(GoRouterPaths.loginRoute);
          },
          child: const Icon(Icons.logout),
        );
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  final HomeResponseEntity product;

  const HomeContent({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryItems(category: product.category),
            const SizedBox(height: 10),
            Visibility(
              visible: product.homebanner.isNotEmpty,
              child: CarouselImageSlider(homebanner: product.homebanner),
            ),
            SectionTitle(
              title: StringConstant.trendingOffer,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Visibility(
              visible: product.homebanner.isNotEmpty,
              child: TrendingOfferWidget(homebanner: product.homebanner),
            ),
            SectionTitle(
              title: StringConstant.dealOfDay,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Visibility(
              visible: product.homebanner.isNotEmpty,
              child: DealOfTheDayWidget(homebanner: product.homebanner),
            ),
            SectionTitle(
              title: StringConstant.ourCollection,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: product.products.length,
              itemBuilder: (context, index) {
                final products = product.products[index];
                return BlocBuilder<AddCartCubit, AddCartState>(
                  builder: (context, state) {
                    return ProductCard(
                      products: products,
                      isLoading:
                          context.read<AddCartCubit>().isLoading(products.id),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
