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

  // Factory constructor to parse JSON into a ProductEntity instance
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['_id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: List<String>.from(json['image'] as List),
      offerPercentage: (json['offerPercentage'] as num).toDouble(),
      actualPrice: (json['actualPrice'] as num).toDouble(),
      offerPrice: (json['offerPrice'] as num).toDouble(),
    );
  }

  @override
  List<Object> get props => [id];
}
