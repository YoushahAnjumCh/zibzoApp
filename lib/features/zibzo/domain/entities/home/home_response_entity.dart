// import 'package:zibzo_app/features/zibzo/domain/entities/home/home_banner_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/category_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_banner_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/offer_banner_entity.dart';

class HomeResponseEntity {
  final List<ProductEntity> products;
  final List<HomeBannerEntity> homebanner;
  final List<CategoryEntity> category;
  final List<OfferBannerEntity> offerbanner;

  const HomeResponseEntity({
    required this.products,
    required this.homebanner,
    required this.category,
    required this.offerbanner,
  });
}
