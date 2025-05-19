import 'package:flutter/material.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/features/zibzo/presentation/search/widgets/custom_image_widget.dart';

class CategoryNotFound extends StatelessWidget {
  const CategoryNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageWidget(
          path: AssetsPath.notFound,
          height: 230,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10),
        Text(
          StringConstant.searchNotFound,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}
