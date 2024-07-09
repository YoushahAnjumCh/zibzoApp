import 'package:equatable/equatable.dart';
import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';

class Products extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;
  const Products({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
  @override
  List<Object?> get props => [id];
}

class Rating {
  final double rate;
  final int count;
  const Rating({
    required this.rate,
    required this.count,
  });
}
