import 'package:flutter/material.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';

import 'package:zibzo_app/features/zibzo/presentation/cart/widgets/cart_item_widget.dart';

class CartItemsWidget extends StatelessWidget {
  final List<ProductEntity> products;

  const CartItemsWidget({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return CartItemWidget(product: products[index]);
      },
    );
  }
}
