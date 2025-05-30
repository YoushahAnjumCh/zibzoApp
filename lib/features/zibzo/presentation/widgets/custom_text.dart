import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';

class CustomText extends StatelessWidget {
  final CustomTextAttributes attributes;
  const CustomText({Key? key, required this.attributes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: attributes.padding ?? const EdgeInsets.only(),
      child: Text(
        overflow: attributes.overflow,
        maxLines: attributes.maxLines,
        textAlign: attributes.textAlign,
        attributes.title,
        style: attributes.style,
      ),
    );
  }
}
