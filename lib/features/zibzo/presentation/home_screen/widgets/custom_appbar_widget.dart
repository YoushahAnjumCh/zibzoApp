import 'package:flutter/material.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key}) : super(key: key);

  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: Future.wait([
        appSecureStorage.getCredential("image"),
        appSecureStorage.getCredential("userName"),
      ]).then((values) => {
            'image': values[0],
            'userName': values[1],
          }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            title: CustomText(
                attributes: CustomTextAttributes(
              title: '',
            )),
          );
        } else if (snapshot.hasError) {
          return AppBar(
            title: CustomText(
                attributes: CustomTextAttributes(
              title: '',
            )),
          );
        } else {
          final image = snapshot.data?['image'];
          final userName = snapshot.data?['userName'];

          return AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                image != null && image.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: image.startsWith('http')
                            ? NetworkImage(image)
                            : null,
                      )
                    : SizedBox.shrink(),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                      attributes: CustomTextAttributes(
                    title: userName ?? 'Guest',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  )),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined,
                    color: Colors.black),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
