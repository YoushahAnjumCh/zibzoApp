import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zibzo/core/failure/failure.dart';
import 'package:zibzo/core/typedef/typedef.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_products_entity.dart';
import 'package:zibzo/features/zibzo/domain/repositories/search/search_repository.dart';

class SearchProductUseCase {
  final SearchRepository repository;
  final BehaviorSubject<String> searchSubject = BehaviorSubject<String>();

  final BehaviorSubject<Either<Failure, List<ProductEntity>>> _resultStream =
      BehaviorSubject<Either<Failure, List<ProductEntity>>>();

  SearchProductUseCase({required this.repository}) {
    searchSubject
        .distinct()
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) async {
      if (query.isEmpty) {
        _resultStream.add(const Right([]));
        return;
      }
      final result =
          await repository.searchProduct(SearchUseCaseParams(query: query));
      _resultStream.add(result);
    });
  }

  void search(String query) {
    searchSubject.add(query);
  }

  void clearCache() {
    searchSubject.add('');
  }

  ResultStream<List<ProductEntity>> get results => _resultStream.stream;

  void dispose() {
    searchSubject.close();
    _resultStream.close();
  }
}

class SearchUseCaseParams {
  final String query;
  final int limit;
  final int offset;

  SearchUseCaseParams({
    required this.query,
    this.limit = 10,
    this.offset = 0,
  });
}
