import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/cart/cart_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/category_products_data_source/category_prod_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/products/product_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/auth/user_repositories.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/cart/cart_repository_impl.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/category_products/category_products_repository_impl.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/product/product_repositories.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/cart/cart_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/category_products/category_products_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/home/home_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/add_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/cart/get_cart_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/category_products/category_products_use_case.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/shared_preferences/shared_preferences_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => UserBloc(sl()),
  );

  sl.registerFactory(
    () => SignInBloc(sl()),
  );
  sl.registerFactory(
    () => CartBloc(sl(), sl()),
  );

  sl.registerFactory(
    () => ProductBloc(sl()),
  );
  sl.registerFactory(
    () => SharedPreferencesCubit(sl(), sl(), sl()),
  );
  sl.registerFactory(
    () => AddCartCubit(sl()),
  );
  sl.registerFactory(
    () => CategoryProductBloc(sl()),
  );
  //UseCase
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => ProductUseCase(sl()));
  sl.registerLazySingleton(() => SharedPreferencesLoginUseCase(sl()));
  sl.registerLazySingleton(() => SharedPreferencesLoginStatusUseCase(sl()));
  sl.registerLazySingleton(() => SharedPreferencesLogoutUseCase(sl()));
  sl.registerLazySingleton(() => CategoryProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddCartUseCase(cartRepository: sl()));
  sl.registerLazySingleton(() => DeleteCartUseCase(cartRepository: sl()));
  sl.registerLazySingleton(() => GetCartUseCase(cartRepository: sl()));

  //Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<CategoryProductsRepository>(
    () => CategoryProductsRepoImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      cartDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<UserDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<ProductDataSource>(
      () => ProductRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<CategoryProductDataSource>(
      () => CategoryProductRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<CartDataSource>(
      () => CartRemoteDataSourceImpl(client: sl()));

  //Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // FlutterSecureStorage
  sl.registerLazySingleton<AppLocalStorage>(
    () => FlutterSecureStorageAdapter(),
  );

  // SharedPreferences
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // sl.registerLazySingleton<AppLocalStorage>(
  //   () => FlutterSharedPreferenceStorageAdapter(sl()),
  // );
  // sl.registerLazySingleton<AppLocalStorage>(
  //   () => FlutterSharedPreferenceStorageAdapter(sharedPreferences),
  // instanceName: 'sharedPreferences',
  // );
}
