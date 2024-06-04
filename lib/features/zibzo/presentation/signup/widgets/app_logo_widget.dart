import 'package:flutter/widgets.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/app_logo_widget_attributes.dart';

class AppLogoWidget extends StatelessWidget {
  final AppLogoWidgetAttributes attributes;
  const AppLogoWidget({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      attributes.icon,
      height: attributes.height,
      width: attributes.width,
      fit: BoxFit.cover,
    );
  }
}
