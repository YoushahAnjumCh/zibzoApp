import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:zibzo_app/core/network_info/network_info.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/features/zibzo/data/datasources/auth/remote/user_remote_data_sources.dart';
import 'package:zibzo_app/features/zibzo/data/repositories/auth/user_repositories.dart';
import 'package:zibzo_app/features/zibzo/domain/repositories/signup/signup_repository.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
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
  //UseCase
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));

  //Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()),
  );

  // Datasources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //FlutterSecureStorage
  sl.registerLazySingleton<AppSecureStorage>(
    () => FlutterSecureStorageAdapter(),
  );
}
