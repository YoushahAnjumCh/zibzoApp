import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:either_dart/either.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/usecases/search/search_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchProductUseCase searchProductUseCase;
  StreamSubscription<Either<Failure, List<ProductEntity>>>? _subscription;

  SearchCubit({required this.searchProductUseCase}) : super(SearchInitial()) {
    _initializeSearchStream();
  }

  Future<void> _initializeSearchStream() async {
    await Future.delayed(Duration.zero);
    _subscription = searchProductUseCase.results.listen((result) {
      result.fold(
        (failure) => emit(SearchError(failure.errorMessage.toString())),
        (products) {
          if (searchProductUseCase.searchSubject.value.isNotEmpty) {
            emit(SearchLoaded(products));
          }
        },
      );
    });
  }

  void search(String query) {
    emit(SearchLoading());
    searchProductUseCase.search(query);
  }

  void resetSearch() {
    searchProductUseCase.clearCache();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    searchProductUseCase.dispose();
    return super.close();
  }
}
