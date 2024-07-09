import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/password_notifier.dart';
import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/constant/text_style_constant.dart';
import 'package:zibzo_app/core/constant/widgets_keys.dart';
import 'package:zibzo_app/core/routes/app_routes.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/core/validation/validation.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/app_logo_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/app_logo_widget_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/custom_container_gradient.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/input_form_button.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final AppLocalStorage appSharedPrefStorage =
        sl<AppLocalStorage>(instanceName: 'sharedPreferences');
    final AppLocalStorage appSecureStorage =
        sl<AppLocalStorage>(instanceName: 'secureStorage');

    return BlocListener<SignInBloc, SignInState>(
        listener: (context, state) async {
          if (state is SignInLoading) {
            EasyLoading.show(status: "Loading");
          } else if (state is SignInFail) {
            EasyLoading.showError(state.message);
          } else if (state is SignInSuccess &&
              state.user.token.toString().isNotEmpty) {
            await appSecureStorage.writeToStorage(
                "token", state.user.token.toString());
            await appSharedPrefStorage.writeToStorage(
                "email", state.user.email);
            await appSharedPrefStorage.writeToStorage(
                "firstName", state.user.firstName);
            context.go(GoRouterPaths.homeScreenRoute);
            EasyLoading.dismiss();
          }
        },
        child: Scaffold(
            body: Stack(children: [
          const CustomContainerGradient(
            color: [Colors.white, Colors.blueGrey],
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppLogoWidget(
                      attributes: AppLogoWidgetAttributes(
                        icon: AssetsPath.appLogo,
                        height: 90,
                        width: 90,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      StringConstant.signIn,
                      style: TextStyles.heading1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextFormField(
                        key: const Key(WidgetsKeys.tEmailKey),
                        attributes: InputTextFormFieldAttributes(
                          contentPadding: const EdgeInsets.all(8),
                          controller: email,
                          hint: StringConstant.email,
                          validation: FormValidator.validateEmail,
                          textInputAction: TextInputAction.next,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    ChangeNotifierProvider(
                      create: (_) => PasswordVisibilityNotifier(),
                      child: Consumer<PasswordVisibilityNotifier>(
                        builder: (context, value, child) {
                          return InputTextFormField(
                              key: const Key(WidgetsKeys.tPasswordKey),
                              attributes: InputTextFormFieldAttributes(
                                passwordVisibilityNotifier: value,
                                contentPadding: const EdgeInsets.all(8),
                                controller: password,
                                hint: StringConstant.password,
                                isSecureField: true,
                                validation: FormValidator.validatePassword,
                                textInputAction: TextInputAction.next,
                              ));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputFormButton(
                        key: const Key(WidgetsKeys.tSigninKey),
                        attributes: TextFormButtonAttributes(
                            onClick: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SignInBloc>().add(
                                    SignInButtonEvent(
                                        params: SignInParams(
                                            email: email.text.trim(),
                                            password: password.text.trim())));
                              }
                            },
                            color: Colors.orangeAccent,
                            titleColor: Colors.white,
                            buttonWidthHeight: Size(double.maxFinite, 30),
                            titleText: StringConstant.signIn,
                            cornerRadius: 20)),
                    InputFormButton(
                        attributes: TextFormButtonAttributes(
                            onClick: () {
                              context.push(GoRouterPaths.signupRoute);
                            },
                            color: Colors.orangeAccent,
                            titleColor: Colors.white,
                            buttonWidthHeight: Size(double.maxFinite, 30),
                            titleText: StringConstant.signUp,
                            cornerRadius: 20)),
                  ],
                ),
              ),
            ),
          ),
        ])));
  }
}
