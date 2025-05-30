import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_items_widget.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_loading_widget.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/price_bottom_bar.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _fetchCart();
    _logAnalytics();
  }

  void _fetchCart() {
    context.read<CartBloc>().add(GetCartEvent());
  }

  void _logAnalytics() {
    AnalyticsService().logScreensView('cart_screen', 'CartScreen');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CartState state) {
    return switch (state) {
      CartLoading() => const CartLoadingWidget(),
      CartSuccess(:final cartResponseEntity) => _CartContent(
          products: cartResponseEntity.products,
          cartCount: cartResponseEntity.cartProductCount,
        ),
      CartEmpty(:final message) => _CartError(
          message: message,
          isEmptyCart: true,
        ),
      CartFailure(:final errorCode, :final message) => _CartError(
          message: message,
          isEmptyCart: errorCode == 404,
        ),
      _ => const Center(
          child: CustomText(
              attributes: CustomTextAttributes(title: 'No cart data'))),
    };
  }
}

class _CartContent extends StatelessWidget {
  final List<ProductEntity> products;
  final int cartCount;

  const _CartContent({
    required this.products,
    required this.cartCount,
  });

  static const _padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  @override
  Widget build(BuildContext context) {
    context.read<CartCountProvider>().saveCartCount(cartCount);
    final totalPrice = _calculateTotalPrice();
    return products.isNotEmpty
        ? Stack(
            fit: StackFit.expand,
            children: [
              _buildCartItems(),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PriceBottomBar(totalPrice: totalPrice))
            ],
          )
        : _CartError(
            message: StringConstant.cartEmpty,
            isEmptyCart: true,
          );
  }

  Widget _buildCartItems() {
    return SingleChildScrollView(
      child: Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              attributes: CustomTextAttributes(
                title: StringConstant.myCart,
                style: AppTextStyles.headingMedium,
              ),
            ),
            CartItemsWidget(products: products),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    return products.fold(0.0, (total, product) => total + product.offerPrice);
  }
}

class _CartError extends StatelessWidget {
  final String message;
  final bool isEmptyCart;

  const _CartError({
    required this.message,
    required this.isEmptyCart,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmptyCart) {
      context.read<CartCountProvider>().saveCartCount(0);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                AssetsPath.cartEmpty,
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            CustomText(
              attributes: CustomTextAttributes(
                title: message,
                style:
                    AppTextStyles.headingMedium.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
