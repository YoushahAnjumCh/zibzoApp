import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  const CustomImageWidget(
      {super.key,
      required this.path,
      this.width,
      this.height,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
