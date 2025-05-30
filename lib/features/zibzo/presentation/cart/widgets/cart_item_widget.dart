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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
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
