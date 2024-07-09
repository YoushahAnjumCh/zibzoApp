import 'package:flutter/widgets.dart';

class HomePageTitleText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextStyle? style;
  const HomePageTitleText(
      {super.key, required this.text, this.maxLines, this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        style: style,
      ),
    );
  }
}
