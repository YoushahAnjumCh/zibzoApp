import 'package:flutter/material.dart';
import 'package:zibzo_app/core/constant/string_formatter.dart';
import 'package:zibzo_app/core/theme/color_theme.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/product_images_widget.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity products;

  const ProductCard({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white60.withOpacity(0.4), // Custom shadow color
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 415,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageRow(imageUrls: products.image),
          const SizedBox(height: 16),
          _buildText(context, products.title,
              Theme.of(context).textTheme.headlineSmall, FontWeight.w500),
          const SizedBox(height: 10),
          _buildText(context, products.subtitle,
              Theme.of(context).textTheme.titleLarge, FontWeight.w400),
          const SizedBox(height: 10),
          _buildPriceRow(context, products.actualPrice, products.offerPrice,
              products.offerPercentage),
          const SizedBox(height: 10),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context, String text, TextStyle? style,
      FontWeight fontWeight) {
    return Text(
      text,
      style: style?.copyWith(fontWeight: fontWeight),
    );
  }

  Widget _buildPriceRow(BuildContext context, double actualPrice,
      double offerPrice, double offerPercentage) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₹ ${Stringformatter.removeTrailingZeros(actualPrice)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorTheme.borderColor,
                decoration: TextDecoration.lineThrough,
              ),
        ),
        const SizedBox(width: 13),
        Text(
          '₹ ${Stringformatter.removeTrailingZeros(offerPrice)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 13),
        Text(
          "(${Stringformatter.removeTrailingZeros(offerPercentage)}% Off)",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: ColorTheme.successColor,
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOutlinedButton("Wishlist", Icons.favorite_border, () {
          // Wishlist button action
        }),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ColorTheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              // Add to Bag button action
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "Add to Bag",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinedButton(
      String label, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
