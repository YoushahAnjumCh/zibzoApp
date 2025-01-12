import 'package:zibzo/features/zibzo/domain/entities/home/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required String id,
    required String title,
    required String image,
  }) : super(
          id: id,
          title: title,
          image: image,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': image,
    };
  }
}
