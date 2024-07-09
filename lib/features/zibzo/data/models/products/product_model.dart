import 'package:json_annotation/json_annotation.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Products {
  const ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required String category,
    required String image,
    required RatingModel rating,
  }) : super(
          category: category,
          description: description,
          id: id,
          image: image,
          price: price,
          title: title,
          rating: rating,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class RatingModel extends Rating {
  const RatingModel({
    required double rate,
    required int count,
  }) : super(
          rate: rate,
          count: count,
        );

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
