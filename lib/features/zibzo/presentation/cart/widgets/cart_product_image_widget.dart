import 'package:flutter/material.dart';

class CartProductImageWidget extends StatelessWidget {
  final String imageUrl;

  const CartProductImageWidget({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(
            imageUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
