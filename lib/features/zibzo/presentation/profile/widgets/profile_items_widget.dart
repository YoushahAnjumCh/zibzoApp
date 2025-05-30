import 'package:flutter/material.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';

class ProfileItemsWidget extends StatelessWidget {
  final IconData icons;
  final String itemName;
  final VoidCallback tap;
  const ProfileItemsWidget(
      {super.key,
      required this.icons,
      required this.itemName,
      required this.tap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 0, 30, 40),
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(
              icons,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(
              width: 18,
            ),
            CustomText(
              attributes: CustomTextAttributes(
                title: itemName,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
