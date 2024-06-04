import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomContainerGradient extends StatelessWidget {
  final List<Color> color;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  const CustomContainerGradient(
      {super.key,
      required this.color,
      this.padding,
      this.begin = Alignment.topCenter,
      this.end = Alignment.bottomCenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: color,
        begin: begin,
        end: end,
      )),
    );
  }
}
