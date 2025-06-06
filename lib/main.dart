import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/core/theme/app_theme.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/search/cubit/search_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/signup/bloc/signup_bloc.dart';
import 'package:zibzo/firebase_options.dart';
import 'core/service/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await init();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  runApp(MyApp());
  FirebaseAnalytics.instance.logAppOpen();
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });
  final AppRouter appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartCountProvider()),
        BlocProvider(create: (context) => sl<UserBloc>()),
        BlocProvider(create: (context) => sl<SignInBloc>()),
        BlocProvider(
            create: (context) => sl<ProductBloc>()..add(ProductFetchEvent())),
        BlocProvider(
          create: (context) => AddCartCubit(
            sl(),
          ),
        ),
        BlocProvider(
          create: (context) => SearchCubit(searchProductUseCase: sl()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.router.routerDelegate,
        routeInformationParser: appRouter.router.routeInformationParser,
        routeInformationProvider: appRouter.router.routeInformationProvider,
        builder: EasyLoading.init(),
        title: StringConstant.appName,
        theme: AppTheme.lightTheme,
        themeMode: AppTheme.themeMode,
      ),
    );
  }
}
