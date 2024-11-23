import 'package:flutter/material.dart';
import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key}) : super(key: key);

  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: Future.wait([
        appSecureStorage.getToken("image"),
        appSecureStorage.getToken("userName"),
      ]).then((values) => {
            'image': values[0],
            'userName': values[1],
          }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            title: Text(''),
          );
        } else if (snapshot.hasError) {
          return AppBar(
            title: Text(''),
          );
        } else {
          final image = snapshot.data?['image'];
          final userName = snapshot.data?['userName'];

          return AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: image?.startsWith('http') == true
                      ? NetworkImage(image!)
                      : const AssetImage(AssetsPath.appLogo) as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) {
                    debugPrint('Failed to load network image: $exception');
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userName ?? 'Guest',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.black),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
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
