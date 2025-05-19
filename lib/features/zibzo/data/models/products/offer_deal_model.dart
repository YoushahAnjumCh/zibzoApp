import 'package:zibzo/features/zibzo/domain/entities/home/offer_deal_entity.dart';

class OfferDealModel extends OfferDealEntity {
  const OfferDealModel({
    required String id,
    required String title,
    required String image,
    String? logo,
    String? offer,
  }) : super(
          id: id,
          title: title,
          image: image,
          logo: logo,
          offer: offer,
        );

  factory OfferDealModel.fromJson(Map<String, dynamic> json) {
    return OfferDealModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      logo: json['logo'] as String,
      offer: json['offer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': image,
      'logo': logo,
      'offer': offer,
    };
  }
}
