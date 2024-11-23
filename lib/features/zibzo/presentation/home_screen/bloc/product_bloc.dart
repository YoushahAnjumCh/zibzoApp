import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUseCase useCase;
  ProductBloc(this.useCase) : super(ProductInitial()) {
    on<ProductFetchEvent>(_getProducts);
  }
  Future<void> _getProducts(
      ProductFetchEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final products = await useCase.call();
      products.fold(
          (left) =>
              emit(ProductFail(errorMessage: left.errorMessage.toString())),
          (products) => emit(ProductLoaded(product: products)));
    } on ServerFailure catch (e) {
      emit(ProductFail(errorMessage: e.errorMessage.toString()));
    }
  }
}
