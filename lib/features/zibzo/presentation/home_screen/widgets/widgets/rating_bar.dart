import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRatingBar extends StatelessWidget {
  final double rating;
  final int count;
  const AppRatingBar({super.key, required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          itemSize: 12,
          initialRating: rating,
          minRating: 1,
          allowHalfRating: true,
          ignoreGestures: true,
          direction: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
        ),
      ],
    );
  }
}
