import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/products/product_remote_data_source.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/auth/user_repositories.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/product/product_repositories.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/product/product_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/home_page/product_use_case.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
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
    () => ProductBloc(sl()),
  );
  //UseCase
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => ProductUseCase(sl()));

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

  // Datasources
  sl.registerLazySingleton<UserDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<ProductDataSource>(
      () => ProductRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // FlutterSecureStorage
  sl.registerLazySingleton<AppLocalStorage>(
    () => FlutterSecureStorageAdapter(),
    instanceName: 'secureStorage',
  );

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<AppLocalStorage>(
    () => FlutterSharedPreferenceStorageAdapter(sharedPreferences),
    instanceName: 'sharedPreferences',
  );
}
