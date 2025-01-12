import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final List<String> image;
  final double offerPercentage;
  final double actualPrice;
  final double offerPrice;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.offerPercentage,
    required this.actualPrice,
    required this.offerPrice,
  });

  @override
  List<Object> get props => [id];
}
