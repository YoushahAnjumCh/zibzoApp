import 'package:flutter/material.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';

class PriceRowWidget extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;

  const PriceRowWidget(
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
