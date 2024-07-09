import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/password_notifier.dart';
import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/constant/text_style_constant.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/core/validation/validation.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/app_logo_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/app_logo_widget_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/custom_container_gradient.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/input_form_button.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AppLocalStorage appSharedPrefStorage =
      sl<AppLocalStorage>(instanceName: 'sharedPreferences');
  final AppLocalStorage appSecureStorage =
      sl<AppLocalStorage>(instanceName: 'secureStorage');

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is UserLoading) {
            EasyLoading.show(status: 'Loading...');
          } else if (state is UserLogged) {
            final email = await appSharedPrefStorage.readFromStorage("email");
            log(email.toString());
            final token = await appSecureStorage.readFromStorage("token");
            log(token.toString());

            EasyLoading.dismiss();
          } else if (state is UserLoggedFail) {
            EasyLoading.showToast(state.failure);
            EasyLoading.dismiss();
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              const CustomContainerGradient(
                color: [Colors.white, Colors.blueGrey],
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppLogoWidget(
                            attributes: AppLogoWidgetAttributes(
                                icon: AssetsPath.appLogo,
                                height: 90,
                                width: 90)),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          StringConstant.signUp,
                          style: TextStyles.heading1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextFormField(
                          attributes: InputTextFormFieldAttributes(
                              contentPadding: const EdgeInsets.all(8),
                              controller: firstNameController,
                              hint: StringConstant.firstName,
                              textInputAction: TextInputAction.next,
                              validation: FormValidator.validateNotEmpty),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        InputTextFormField(
                          attributes: InputTextFormFieldAttributes(
                              contentPadding: const EdgeInsets.all(8),
                              controller: lastNameController,
                              hint: StringConstant.lastName,
                              textInputAction: TextInputAction.next,
                              validation: FormValidator.validateNotEmpty),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        InputTextFormField(
                          attributes: InputTextFormFieldAttributes(
                              contentPadding: const EdgeInsets.all(8),
                              controller: emailController,
                              hint: StringConstant.email,
                              textInputAction: TextInputAction.next,
                              validation: FormValidator.validateEmail),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ChangeNotifierProvider(
                          create: (_) => PasswordVisibilityNotifier(),
                          child: Consumer<PasswordVisibilityNotifier>(
                            builder: (context, value, child) {
                              return InputTextFormField(
                                attributes: InputTextFormFieldAttributes(
                                    contentPadding: const EdgeInsets.all(8),
                                    passwordVisibilityNotifier: value,
                                    controller: passwordController,
                                    hint: StringConstant.password,
                                    textInputAction: TextInputAction.next,
                                    isSecureField: true,
                                    validation: FormValidator.validatePassword),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ChangeNotifierProvider(
                          create: (_) => PasswordVisibilityNotifier(),
                          child: Consumer<PasswordVisibilityNotifier>(
                            builder: (context, passwordValue, child) {
                              return InputTextFormField(
                                attributes: InputTextFormFieldAttributes(
                                  contentPadding: const EdgeInsets.all(8),
                                  passwordVisibilityNotifier: passwordValue,
                                  controller: confirmPasswordController,
                                  hint: StringConstant.confirmPassword,
                                  isSecureField: true,
                                  textInputAction: TextInputAction.go,
                                  validation: FormValidator.validatePassword,
                                  onFieldSubmitted: (_) {
                                    if (_formKey.currentState!.validate()) {
                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                      } else {
                                        context
                                            .read<UserBloc>()
                                            .add(SignupUser(SignUpParams(
                                              firstName:
                                                  firstNameController.text,
                                              lastName: lastNameController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                            )));
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InputFormButton(
                                attributes: TextFormButtonAttributes(
                                  buttonWidthHeight:
                                      const Size(double.maxFinite, 30),
                                  titleColor: Colors.white,
                                  color: Colors.orangeAccent,
                                  onClick: () {
                                    Navigator.of(context).pop();
                                  },
                                  titleText: StringConstant.back,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: InputFormButton(
                                attributes: TextFormButtonAttributes(
                                  buttonWidthHeight:
                                      const Size(double.maxFinite, 30),
                                  titleColor: Colors.white,
                                  color: Colors.orangeAccent,
                                  onClick: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        EasyLoading.showError(StringConstant
                                            .passwordConfirmError);
                                      } else {
                                        context
                                            .read<UserBloc>()
                                            .add(SignupUser(SignUpParams(
                                              firstName:
                                                  firstNameController.text,
                                              lastName: lastNameController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                            )));
                                      }
                                    }
                                  },
                                  titleText: StringConstant.signUp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
