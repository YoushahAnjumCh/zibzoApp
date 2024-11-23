import 'package:zibzo_app/core/typedef/typedef.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_response_entity.dart';

abstract class ProductRepository {
  ResultFuture<HomeResponseEntity> getProducts();
}
