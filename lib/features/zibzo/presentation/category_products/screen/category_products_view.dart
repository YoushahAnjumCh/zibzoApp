import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/widgets/category_loading_widget.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/widgets/category_not_found.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/product_card_widget.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class CategoryProductsView extends StatelessWidget {
  final String categoryName;

  const CategoryProductsView({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnalyticsService().logScreensView(
      'category_screen',
      'CategoryScreen',
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<CategoryProductBloc, CategoryProductState>(
        builder: (context, state) {
          if (state is CategoryProductLoading) {
            return CategoryLoadingWidget();
          } else if (state is CategoryProductSuccess) {
            return ProductList(products: state.product);
          } else if (state is CategoryProductFailure) {
            return ErrorMessage(message: state.message);
          } else {
            return const Center(
                child: CustomText(
                    attributes:
                        CustomTextAttributes(title: 'No products available.')));
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(color: Colors.black, onPressed: () => context.pop()),
      title: CustomText(
        attributes: CustomTextAttributes(
            title: categoryName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                )),
      ),
      actions: [
        Consumer<CartCountProvider>(builder: (context, cartProvider, child) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                IconButton(
                    onPressed: () =>
                        context.push(GoRouterPaths.cartScreenRoute),
                    color: Colors.black,
                    icon: const Icon(Icons.shopping_cart)),
                if (cartProvider.cartCount > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: CustomText(
                          attributes: CustomTextAttributes(
                            title: cartProvider.cartCount.toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        )),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class ProductList extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const CategoryNotFound();
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          products: products[index],
          isLoading: context.read<AddCartCubit>().isLoading(products[index].id),
        );
      },
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
