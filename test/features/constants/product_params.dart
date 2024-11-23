import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo_app/features/zibzo/data/models/products/product_response_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

const tProductParams = ProductsParams(limit: 1, offset: 10);

const tProducts = [tProduct];

const tProduct = ProductEntity(
  actualPrice: 1200,
  id: "1",
  image: ["image"],
  offerPercentage: 20,
  offerPrice: 20,
  subtitle: "subtitle",
  title: "title",
);

const tProductModel = ProductModel(
  actualPrice: 1200,
  id: "1",
  image: ["image"],
  offerPercentage: 20,
  offerPrice: 20,
  subtitle: "subtitle",
  title: "title",
);

const tProductResponse = ProductResponseModel(products: [
  tProductModel,
], homebanner: [], offerbanner: [], category: []);

const tHomeResponseEntity = HomeResponseEntity(
  category: [],
  homebanner: [],
  offerbanner: [],
  products: tProducts,
);
