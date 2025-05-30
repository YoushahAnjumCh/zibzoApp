import 'package:flutter/material.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/features/zibzo/presentation/cart/widgets/cart_checkout_button.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';

class PriceBottomBar extends StatelessWidget {
  final double totalPrice;
  const PriceBottomBar({super.key, required this.totalPrice});
  static const _bottomBarHeightFactor = 0.11;
  static const _bottomBarShadow = BoxShadow(
    color: Color(0x1A000000),
    spreadRadius: 3,
    blurRadius: 2,
    offset: Offset(0, -2),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * _bottomBarHeightFactor,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [_bottomBarShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildPriceSection(context, totalPrice),
            const SizedBox(width: 46),
            const Expanded(child: CartCheckoutButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context, double totalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
            attributes: CustomTextAttributes(
          title: StringConstant.totalPrice,
          style: Theme.of(context).textTheme.labelMedium,
        )),
        CustomText(
            attributes: CustomTextAttributes(
          title: '₹${totalPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        )),
      ],
    );
  }
}
