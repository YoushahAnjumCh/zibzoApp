import 'package:equatable/equatable.dart';
import 'package:zibzo_app/core/failure/failure.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/category_products/category_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_product_event.dart';
part 'category_product_state.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final CategoryProductsUseCase useCase;

  CategoryProductBloc(this.useCase) : super(CategoryProductInitial()) {
    on<CategoryProductEvent>((event, emit) async {
      try {
        emit(CategoryProductLoading());
        final result = await useCase.call(event.categoryName);
        result.fold((left) {
          emit(CategoryProductFailure(left.errorMessage.toString()));
        }, (right) {
          emit(CategoryProductSuccess(right));
        });
      } on ServerFailure catch (e) {
        emit(CategoryProductFailure(e.errorMessage.toString()));
      }
    });
  }
}
