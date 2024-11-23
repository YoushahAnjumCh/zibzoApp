import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/routes/app_routes.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/carousel_slider.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/category_items.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/custom_appbar_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/deal_of_the_day_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/product_card_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/trending_offer_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              return HomeContent(product: state.product);
            } else {
              return const Center(child: Text(StringConstant.somethingWrong));
            }
          },
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return BlocBuilder<SharedPreferencesCubit, AuthState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
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
    return SingleChildScrollView(
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
          const SectionTitle(title: StringConstant.trendingOffer),
          Visibility(
            visible: product.homebanner.isNotEmpty,
            child: TrendingOfferWidget(homebanner: product.homebanner),
          ),
          const SectionTitle(title: StringConstant.dealOfDay),
          Visibility(
            visible: product.homebanner.isNotEmpty,
            child: DealOfTheDayWidget(homebanner: product.homebanner),
          ),
          const SectionTitle(title: StringConstant.ourCollection),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: product.products.length,
            itemBuilder: (context, index) {
              return ProductCard(products: product.products[index]);
            },
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
