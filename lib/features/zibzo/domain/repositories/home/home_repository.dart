import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';

abstract class ProductRepository {
  ResultFuture<HomeResponseEntity> getProducts();
}
