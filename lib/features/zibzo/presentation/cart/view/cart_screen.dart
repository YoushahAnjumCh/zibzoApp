import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_checkout_button.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_items_widget.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_loading_widget.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/price_row_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/section_title.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<CartBloc>(context).add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsService().logScreensView(
      'cart_screen',
      'CartScreen',
    );

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const CartLoadingWidget();
            } else if (state is CartSuccess) {
              _updateCartCount(state.cartResponseEntity.cartProductCount);
              return _buildCartContent(state.cartResponseEntity.products);
            } else if (state is CartFailure) {
              if (state.errorCode == 404) {
                _updateCartCount(0);
              }
              return _buildCartFailure(state.message);
            } else {
              return const Center(child: Text("No cart Data"));
            }
          },
        ),
      ),
    );
  }

  void _updateCartCount(int count) {
    Provider.of<CartCountProvider>(context, listen: false).saveCartCount(count);
  }

  Widget _buildCartFailure(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: "Your Cart",
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                message,
                style:
                    AppTextStyles.headingMedium.copyWith(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(List<ProductEntity> products) {
    double totalPrice = _calculateTotalPrice(products);
    double totalWithShipping = totalPrice + 40;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "Your Cart",
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: 24),
            CartItemsWidget(products: products),
            const SizedBox(height: 10),
            PriceRowWidget(
                label: "Items (${products.length})", amount: totalPrice),
            PriceRowWidget(label: "Shipping", amount: 40),
            const Divider(thickness: 1, color: Colors.grey),
            PriceRowWidget(
                label: "Total Price", amount: totalWithShipping, isBold: true),
            const SizedBox(height: 41),
            const CartCheckoutButton(),
          ],
        ),
      ),
    );
  }

  double _calculateTotalPrice(List<ProductEntity> products) {
    return products.fold(0.0, (total, product) => total + product.offerPrice);
  }
}
