import 'package:zibzo/features/zibzo/domain/entities/home/home_banner_entity.dart';

class HomeBannerModel extends HomeBannerEntity {
  const HomeBannerModel({
    required String id,
    required String title,
    required String image,
  }) : super(
          id: id,
          title: title,
          image: image,
        );

  // Factory method to create an instance of HomeBannerModel from JSON
  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }

  // Method to convert an instance of HomeBannerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }
}
