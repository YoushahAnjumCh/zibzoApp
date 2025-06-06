import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/constant/string_formatter.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/product_images_widget.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity products;
  final bool isLoading;

  ProductCard({
    Key? key,
    required this.products,
    required this.isLoading,
  }) : super(key: key);

  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.4),
            offset: Offset(0, 2),
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
          _buildText(context, products.productName,
              Theme.of(context).textTheme.labelLarge, FontWeight.w500),
          const SizedBox(height: 10),
          _buildText(context, products.brand,
              Theme.of(context).textTheme.labelSmall, FontWeight.w400),
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
    return CustomText(
        attributes: CustomTextAttributes(
      title: text,
      style: style?.copyWith(fontWeight: fontWeight),
    ));
  }

  Widget _buildPriceRow(BuildContext context, double actualPrice,
      double offerPrice, double offerPercentage) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
            attributes: CustomTextAttributes(
          title: '₹ ${Stringformatter.removeTrailingZeros(actualPrice)}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        )),
        const SizedBox(width: 13),
        CustomText(
            attributes: CustomTextAttributes(
          title: '₹ ${Stringformatter.removeTrailingZeros(offerPrice)}',
          style: Theme.of(context).textTheme.labelLarge,
        )),
        const SizedBox(width: 13),
        CustomText(
          attributes: CustomTextAttributes(
            title:
                "(${Stringformatter.removeTrailingZeros(offerPercentage)}% Off)",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.scrim,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOutlinedButton("Wishlist", Icons.favorite_border, () {}, context),
        const SizedBox(width: 10),
        Expanded(
          child: BlocConsumer<AddCartCubit, AddCartState>(
            listener: (context, state) {
              if (state is AddCartLoaded) {
                EasyLoading.showSuccess("Product added to cart");
              } else if (state is AddCartFailure) {
                EasyLoading.showError(state.errorMessage);
              }
            },
            builder: (context, state) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  final cartCountProvider =
                      Provider.of<CartCountProvider>(context, listen: false);
                  AnalyticsService().logAddToCart(products.id);
                  final params = AddCartParams(
                    productId: products.id,
                  );
                  final cartCount =
                      await context.read<AddCartCubit>().addCart(params);
                  if (cartCount != null) {
                    cartCountProvider.saveCartCount(cartCount);
                  }
                },
                child: BlocSelector<AddCartCubit, AddCartState, bool>(
                  selector: (state) =>
                      context.read<AddCartCubit>().isLoading(products.id),
                  builder: (context, isLoading) {
                    return isLoading
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomText(
                                attributes: CustomTextAttributes(
                                  title: "Add to Bag",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              Icon(Icons.shopping_bag_outlined,
                                  color: Colors.white),
                            ],
                          );
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildOutlinedButton(String label, IconData icon,
      VoidCallback onPressed, BuildContext context) {
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
            CustomText(
              attributes: CustomTextAttributes(
                  title: label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
