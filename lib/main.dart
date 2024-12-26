import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/provider/cart_count_provider.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/routes/app_routes.dart';
import 'package:zibzo_app/core/theme/app_theme.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup_bloc.dart';
import 'core/service/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartCountProvider()),
        BlocProvider(create: (context) => sl<UserBloc>()),
        BlocProvider(create: (context) => sl<SignInBloc>()),
        BlocProvider(
            create: (context) => sl<ProductBloc>()..add(ProductFetchEvent())),
        BlocProvider(
          create: (context) =>
              SharedPreferencesCubit(sl(), sl(), sl())..checkLoginStatus(),
        ),
        BlocProvider(
          create: (context) => AddCartCubit(
            sl(),
          ),
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
