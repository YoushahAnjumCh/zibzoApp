import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

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
                child: CustomText(
                  attributes: CustomTextAttributes(
                    title: product.productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
              IconButton(
                icon: Image.asset(
                  AssetsPath.trash,
                  width: 24,
                  height: 24,
                ),
                onPressed: () => _deleteProductFromCart(context, product.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomText(
                  attributes: CustomTextAttributes(
                title: "₹${product.offerPrice}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              )),
              Spacer(),
              Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.withOpacity(0.2)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove, size: 16, color: Colors.black),
                        const SizedBox(width: 4),
                        //TODO: Will implement quantity change later
                        CustomText(
                          attributes: CustomTextAttributes(
                            title: "1",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),
                        Icon(Icons.add, size: 16, color: Colors.black),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void _deleteProductFromCart(BuildContext context, String productId) {
    AnalyticsService().logRemoveToCart(productId);
    final params = DeleteCartParams(productID: productId);
    CartCountProvider().deleteCart();
    context.read<CartBloc>().add(DeleteCartEvent(params: params));
  }
}
