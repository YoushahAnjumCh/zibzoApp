import 'package:equatable/equatable.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/products_variants.dart';

class ProductEntity extends Equatable {
  final String id;
  final String productName;
  final String brand;
  final String category;
  final String description;
  final List<String> image;
  final Map<String, ProductVariant> variants; // Dynamic key-value pairs
  final double offerPercentage;
  final double actualPrice;
  final double offerPrice;

  const ProductEntity({
    required this.id,
    this.variants = const {},
    required this.productName,
    required this.category,
    required this.description,
    required this.brand,
    required this.image,
    required this.offerPercentage,
    required this.actualPrice,
    required this.offerPrice,
  });

  @override
  List<Object> get props => [id];
}
