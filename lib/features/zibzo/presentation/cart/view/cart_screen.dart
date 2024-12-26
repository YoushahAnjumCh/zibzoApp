import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/provider/cart_count_provider.dart';
import 'package:zibzo_app/core/theme/app_text_styles.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/widgets/cart_checkout_button.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/widgets/cart_items_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/section_title.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<CartBloc>(context).add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
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
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
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
            PriceRow(label: "Items (${products.length})", amount: totalPrice),
            PriceRow(label: "Shipping", amount: 40),
            const Divider(thickness: 1, color: Colors.grey),
            PriceRow(
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

class PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;

  const PriceRow(
      {Key? key,
      required this.label,
      required this.amount,
      this.isBold = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isBold ? AppTextStyles.headingMedium : null),
        Text("₹${amount.toStringAsFixed(2)}",
            style: isBold ? AppTextStyles.headingMedium : null),
      ],
    );
  }
}
