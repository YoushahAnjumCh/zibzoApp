import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_product_detail_widget.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_product_image_widget.dart';

class CartItemWidget extends StatelessWidget {
  final ProductEntity product;

  const CartItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSecondary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          CartProductImageWidget(imageUrl: product.image[0]),
          const SizedBox(width: 12),
          CartProductDetailWidget(product: product),
        ],
      ),
    );
  }
}
