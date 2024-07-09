import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

const tProductParams = ProductsParams(limit: 1, offset: 10);

const tProducts = [
  Products(
      id: 1,
      title: "title",
      price: 1200,
      description: "description",
      category: "Laptop",
      image: "image",
      rating: RatingModel(count: 1, rate: 3.2))
];

const tProduct = Products(
    id: 1,
    title: "title",
    price: 1200,
    description: "description",
    category: "Laptop",
    image: "image",
    rating: RatingModel(count: 1, rate: 3.2));

const tProductModel = ProductModel(
    id: 1,
    title: "title",
    description: "description",
    price: 1200,
    category: "laptop",
    image: "image",
    rating: tRating);

const tRating = RatingModel(count: 1, rate: 3.2);
