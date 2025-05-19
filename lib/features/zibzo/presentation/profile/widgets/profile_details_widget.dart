import 'package:flutter/material.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';

class ProfileDetailsWidget extends StatelessWidget {
  ProfileDetailsWidget({super.key});
  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: Future.wait([
        appSecureStorage.getCredential("image"),
        appSecureStorage.getCredential("userName"),
        appSecureStorage.getCredential("email"),
      ]).then((values) => {
            'image': values[0],
            'userName': values[1],
            'email': values[2],
          }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final image = snapshot.data?['image'];
            final userName = snapshot.data?['userName'];
            final email = snapshot.data?['email'];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  SizedBox(
                    height: 57,
                    width: 57,
                    child: CircleAvatar(
                      backgroundImage: image?.startsWith('http') == true
                          ? NetworkImage(image!)
                          : const AssetImage(AssetsPath.appLogo)
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? "",
                        style: AppTextStyles.headingMedium
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        email ?? "",
                        style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(''));
          }
        }

        return SizedBox.shrink();
      },
    );
  }
}
