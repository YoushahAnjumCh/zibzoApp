import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/theme/color_theme.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/category_entity.dart';

class CategoryItems extends StatelessWidget {
  final List<CategoryEntity> category;
  const CategoryItems({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: category.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.only(left: 22),
              child: Column(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorTheme.lightBlueColor,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: SvgPicture.asset(
                          AssetsPath.categoryIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    StringConstant.categories,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            );
          } else {
            final categoryitems = category[index - 1];
            return Container(
              margin: const EdgeInsets.only(left: 12, right: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => context.pushNamed(
                      'categoryProducts',
                      pathParameters: {'categoryName': categoryitems.title},
                    ),
                    child: Container(
                      height: 62,
                      width: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "http://localhost:4000/${categoryitems.image}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    categoryitems.title,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
