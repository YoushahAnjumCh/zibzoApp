import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo_app/core/theme/app_colors.dart';
import 'package:zibzo_app/core/theme/app_text_styles.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';

class CartProductDetailWidget extends StatelessWidget {
  final ProductEntity product;

  const CartProductDetailWidget({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style:
                      AppTextStyles.headingLight.copyWith(color: Colors.black),
                ),
              ),
              IconButton(
                color: Colors.red,
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteProductFromCart(context, product.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "₹${product.offerPrice}",
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.primaryLight),
          ),
        ],
      ),
    );
  }

  void _deleteProductFromCart(BuildContext context, String productId) {
    final params = DeleteCartParams(productID: productId);
    context.read<CartBloc>().add(DeleteCartEvent(params: params));
  }
}
