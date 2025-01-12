import 'package:zibzo/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo/features/zibzo/data/models/products/product_response_model.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/category_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_banner_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/offer_banner_entity.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/offer_deal_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/home_page/product_use_case.dart';

const tProductParams = ProductsParams(limit: 1, offset: 10);

const tProducts = [tProduct, tProduct, tProduct];

const tProduct = ProductEntity(
  actualPrice: 1200,
  id: "1",
  image: [
    "https://via.placeholder.com/150",
  ],
  offerPercentage: 20,
  offerPrice: 20,
  subtitle: "subtitle",
  title: "title",
);

const tProductModel = ProductModel(
  actualPrice: 1200,
  id: "1",
  image: ["image", "image"],
  offerPercentage: 20,
  offerPrice: 20,
  subtitle: "subtitle",
  title: "title",
);

final tProductResponse = ProductResponseModel(cartProductCount: 1, products: [
  tProductModel,
], homebanner: [], offerbanner: [], category: [], offerdeal: []);

const tHomeResponseEntity = HomeResponseEntity(
  offerdeal: [
    OfferDealEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150"),
  ],
  cartProductCount: 4,
  category: [
    CategoryEntity(
        id: "1", image: "https://via.placeholder.com/150", title: "title"),
    CategoryEntity(
        id: "1", image: "https://via.placeholder.com/150", title: "title"),
    CategoryEntity(
        id: "1", image: "https://via.placeholder.com/150", title: "title"),
    CategoryEntity(
        id: "1", image: "https://via.placeholder.com/150", title: "title"),
  ],
  homebanner: [
    HomeBannerEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150"),
    HomeBannerEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150"),
    HomeBannerEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150"),
    HomeBannerEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150"),
    HomeBannerEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150"),
  ],
  offerbanner: [
    OfferBannerEntity(
        id: "id", title: "title", image: "https://via.placeholder.com/150")
  ],
  products: tProducts,
);
