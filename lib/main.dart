import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zibzo_app/core/routes/app_routes.dart';
import 'package:zibzo_app/core/theme/theme.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
import 'core/service/service_locator.dart';

void main() {
  runApp(const MyApp());
  init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserBloc>()),
        BlocProvider(create: (context) => sl<SignInBloc>())
      ],
      child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: appRouter.router.routerDelegate,
          routeInformationParser: appRouter.router.routeInformationParser,
          routeInformationProvider: appRouter.router.routeInformationProvider,
          builder: EasyLoading.init(),
          title: 'Zibzo',
          theme: AppTheme.lightThemeMode),
    );
  }
}
