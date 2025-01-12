import 'package:zibzo/features/zibzo/domain/entities/home/category_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_banner_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/offer_banner_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/offer_deal_entity.dart';

class HomeResponseEntity {
  final List<ProductEntity> products;
  final List<HomeBannerEntity> homebanner;
  final List<CategoryEntity> category;
  final List<OfferBannerEntity> offerbanner;
  final List<OfferDealEntity> offerdeal;
  final int? cartProductCount;

  const HomeResponseEntity({
    required this.products,
    required this.homebanner,
    required this.category,
    required this.offerbanner,
    required this.cartProductCount,
    required this.offerdeal,
  });
}
