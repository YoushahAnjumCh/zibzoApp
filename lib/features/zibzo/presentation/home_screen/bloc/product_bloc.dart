import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUseCase useCase;
  ProductBloc(this.useCase)
      : super(ProductInitial(params: ProductsParams(limit: 3, offset: 0))) {
    on<ProductFetchEvent>(_getProducts);
  }
  Future<void> _getProducts(
      ProductFetchEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final products = await useCase.call(ProductsParams());
      products.fold(
          (left) =>
              emit(ProductFail(errorMessage: left.errorMessage.toString())),
          (products) => emit(ProductLoaded(product: products)));
    } on ServerFailure catch (e) {
      log(e.errorMessage.toString());
      emit(ProductFail(errorMessage: e.errorMessage.toString()));
    }
  }
}
