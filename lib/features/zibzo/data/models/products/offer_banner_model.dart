import 'package:zibzo/features/zibzo/domain/entities/home/offer_banner_entity.dart';

class OfferBannerModel extends OfferBannerEntity {
  const OfferBannerModel({
    required String id,
    required String title,
    required String image,
  }) : super(
          id: id,
          title: title,
          image: image,
        );

  // Factory method to create an instance of HomeBannerModel from JSON
  factory OfferBannerModel.fromJson(Map<String, dynamic> json) {
    return OfferBannerModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }

  // Method to convert an instance of HomeBannerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': image,
    };
  }
}
