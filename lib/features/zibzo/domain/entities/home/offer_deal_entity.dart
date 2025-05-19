class OfferDealEntity {
  final String id;
  final String title;
  final String image;
  final String? logo;
  final String? offer;
  const OfferDealEntity({
    required this.id,
    required this.title,
    required this.image,
    this.logo,
    this.offer,
  });
}
