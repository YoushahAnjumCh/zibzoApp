import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/password_notifier.dart';
import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/core/constant/widgets_keys.dart';
import 'package:zibzo_app/core/routes/app_routes.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/core/theme/color_theme.dart';
import 'package:zibzo_app/core/validation/validation.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/bloc/signup/signup_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/app_logo_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/app_logo_widget_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/input_form_button.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>("");

  final _formKey = GlobalKey<FormState>();
  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is UserLoading) {
            EasyLoading.show(status: 'Loading...');
            await Future.delayed(Duration(seconds: 8));
          } else if (state is UserLogged) {
            EasyLoading.dismiss();
          } else if (state is UserLoggedFail) {
            EasyLoading.dismiss();
            errorMessageNotifier.value = state.failure;
            Future.delayed(Duration(seconds: 5), () {
              errorMessageNotifier.value = "";
            });
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAppLogo(),
                        SizedBox(height: 40),
                        _buildWelcomeText(context),
                        SizedBox(height: 20),
                        _buildErrorMessage(),
                        _buildSignInFields(),
                        SizedBox(height: 20),
                        _buildSignInButton(context),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSignInPrompt(context)
            ],
          ),
        ));
  }

  Widget _buildAppLogo() {
    return AppLogoWidget(
      attributes: AppLogoWidgetAttributes(
        icon: AssetsPath.appLogo,
        height: 72,
        width: 72,
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Text(
          StringConstant.welcomeSignUp,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorTheme.darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          StringConstant.letsMakeAccount,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorTheme.borderColor,
              ),
        ),
      ],
    );
  }

  // Error message display
  Widget _buildErrorMessage() {
    return ValueListenableBuilder<String>(
      valueListenable: errorMessageNotifier,
      builder: (context, errorMessage, child) {
        return errorMessage.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: ColorTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  // Sign-in fields (email and password)
  Widget _buildSignInFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 62),
          _buildUserNameField(),
          SizedBox(height: 20),
          _buildEmailField(),
          SizedBox(height: 20),
          _buildPasswordField(),
          SizedBox(height: 20),
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  // Email input field
  Widget _buildUserNameField() {
    return InputTextFormField(
      key: const Key(WidgetsKeys.tUserNameKey),
      attributes: InputTextFormFieldAttributes(
        prefixIcon: Icon(Icons.person_2, color: ColorTheme.borderColor),
        contentPadding: EdgeInsets.all(8),
        controller: userNameController,
        hint: StringConstant.userName,
        hintColor: ColorTheme.borderColor,
        validation: FormValidator.validateNotEmpty,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  //Email input field
  Widget _buildEmailField() {
    return InputTextFormField(
      attributes: InputTextFormFieldAttributes(
        prefixIcon: Icon(Icons.email, color: ColorTheme.borderColor),
        contentPadding: EdgeInsets.all(8),
        controller: emailController,
        hint: StringConstant.email,
        hintColor: ColorTheme.borderColor,
        validation: FormValidator.validateEmail,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  // Password input field with visibility toggle
  Widget _buildPasswordField() {
    return ChangeNotifierProvider(
      create: (_) => PasswordVisibilityNotifier(),
      child: Consumer<PasswordVisibilityNotifier>(
        builder: (context, value, child) {
          return InputTextFormField(
            key: const Key(WidgetsKeys.tPasswordKey),
            attributes: InputTextFormFieldAttributes(
              prefixIcon: Icon(Icons.lock, color: ColorTheme.borderColor),
              passwordVisibilityNotifier: value,
              contentPadding: EdgeInsets.all(8),
              controller: passwordController,
              hintColor: ColorTheme.borderColor,
              hint: StringConstant.password,
              isSecureField: true,
              validation: FormValidator.validatePassword,
              textInputAction: TextInputAction.next,
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return ChangeNotifierProvider(
      create: (_) => PasswordVisibilityNotifier(),
      child: Consumer<PasswordVisibilityNotifier>(
        builder: (context, value, child) {
          return InputTextFormField(
            // key: const Key(WidgetsKeys.tPasswordKey),
            attributes: InputTextFormFieldAttributes(
              prefixIcon: Icon(Icons.lock, color: ColorTheme.borderColor),
              passwordVisibilityNotifier: value,
              contentPadding: EdgeInsets.all(8),
              controller: confirmPasswordController,
              hintColor: ColorTheme.borderColor,
              hint: StringConstant.confirmPassword,
              isSecureField: true,
              validation: FormValidator.validateConfirmPassword,
              textInputAction: TextInputAction.next,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: InputFormButton(
        attributes: TextFormButtonAttributes(
            buttonWidthHeight: const Size(double.maxFinite, 50),
            titleColor: Colors.white,
            titleText: StringConstant.signUp,
            color: ColorTheme.secondary,
            onClick: () {
              if (_formKey.currentState!.validate()) {
                if (passwordController.text != confirmPasswordController.text) {
                  errorMessageNotifier.value =
                      StringConstant.passwordConfirmError;
                  return;
                }
                context.read<UserBloc>().add(SignupUser(SignUpParams(
                      userName: userNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    )));
                Navigator.of(context).pop();
              }
            }),
      ),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringConstant.alreadyHaveAccount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorTheme.borderColor,
                  ),
            ),
            GestureDetector(
              onTap: () {
                context.push(GoRouterPaths.loginRoute);
              },
              child: Text(
                StringConstant.login,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorTheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
