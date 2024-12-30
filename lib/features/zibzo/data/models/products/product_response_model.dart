import 'dart:convert';

import 'package:zibzo/features/zibzo/data/models/products/category_model.dart';
import 'package:zibzo/features/zibzo/data/models/products/home_banner_model.dart';
import 'package:zibzo/features/zibzo/data/models/products/offer_banner_model.dart';
import 'package:zibzo/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';

ProductResponseModel homeResponseModelFromJson(String str) =>
    ProductResponseModel.fromJson(json.decode(str));

String homeResponseModelToJson(ProductResponseModel data) =>
    json.encode(data.toJson());

class ProductResponseModel extends HomeResponseEntity {
  const ProductResponseModel({
    required List<ProductModel> products,
    required List<HomeBannerModel> homebanner,
    required List<OfferBannerModel> offerbanner,
    required List<CategoryModel> category,
    required int cartProductCount,
  }) : super(
            products: products,
            homebanner: homebanner,
            offerbanner: offerbanner,
            category: category,
            cartProductCount: cartProductCount);

  // Factory method to create an instance of ProductModel from JSON
  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      products: List<ProductModel>.from(
          json["products"].map((x) => ProductModel.fromJson(x))),
      homebanner: List<HomeBannerModel>.from(
          json["homebanner"].map((x) => HomeBannerModel.fromJson(x))),
      category: List<CategoryModel>.from(
          json["category"].map((x) => CategoryModel.fromJson(x))),
      offerbanner: List<OfferBannerModel>.from(
          json["offerbanner"].map((x) => OfferBannerModel.fromJson(x))),
      cartProductCount: json["cartProductCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': List<dynamic>.from(
          (products as List<ProductModel>).map((x) => x.toJson())),
      'homebanner': List<dynamic>.from(
          (homebanner as List<HomeBannerModel>).map((x) => x.toJson())),
      'category': List<dynamic>.from(
          (category as List<CategoryModel>).map((x) => x.toJson())),
      'offerbanner': List<dynamic>.from(
          (offerbanner as List<OfferBannerModel>).map((x) => x.toJson())),
      'cartProductCount': cartProductCount,
    };
  }
}
