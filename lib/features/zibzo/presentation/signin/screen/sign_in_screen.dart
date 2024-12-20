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
import 'package:zibzo_app/features/zibzo/domain/usecases/signin/signin_usecase.dart';
import 'package:zibzo_app/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_event.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/bloc/signin_state.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/app_logo_widget.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/app_logo_widget_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/input_form_button.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>("");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) =>
          _signInStateListener(context, state, appSecureStorage),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSignInForm(context),
                ],
              ),
            ),
            _buildSignUpPrompt(context),
          ],
        ),
      ),
    );
  }

  // Listener method to handle SignIn state changes
  void _signInStateListener(BuildContext context, SignInState state,
      AppLocalStorage appSecureStorage) async {
    if (state is SignInLoading) {
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.black);
      await Future.delayed(Duration(seconds: 8));
      EasyLoading.dismiss();
    } else if (state is SignInFail) {
      EasyLoading.dismiss();
      errorMessageNotifier.value = state.message;
      Future.delayed(Duration(seconds: 5), () {
        errorMessageNotifier.value = "";
      });
    } else if (state is SignInSuccess &&
        state.user.token.toString().isNotEmpty) {
      await appSecureStorage.saveToken("token", state.user.token.toString());
      await appSecureStorage.saveToken("image", state.user.image.toString());
      await appSecureStorage.saveToken(
          "userName", state.user.userName.toString());

      if (context.mounted) {
        context
            .read<SharedPreferencesCubit>()
            .login("token", state.user.token.toString());
        context.go(GoRouterPaths.homeScreenRoute);
      }
      EasyLoading.dismiss();
    }
  }

  // Build the sign-in form UI
  Widget _buildSignInForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            _buildAppLogo(),
            SizedBox(height: 40),
            _buildWelcomeText(context),
            _buildErrorMessage(),
            _buildSignInFields(),
            _buildSignInButton(context),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // App logo widget
  Widget _buildAppLogo() {
    return AppLogoWidget(
      attributes: AppLogoWidgetAttributes(
        icon: AssetsPath.appLogo,
        height: 72,
        width: 72,
      ),
    );
  }

  // Welcome text
  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Text(
          StringConstant.welcomeSignIn,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorTheme.darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          StringConstant.signIn,
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
            ? Text(
                errorMessage,
                style: TextStyle(
                  color: ColorTheme.errorColor,
                  fontWeight: FontWeight.bold,
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
          _buildEmailField(),
          SizedBox(height: 20),
          _buildPasswordField(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  // Email input field
  Widget _buildEmailField() {
    return InputTextFormField(
      key: const Key(WidgetsKeys.tEmailKey),
      attributes: InputTextFormFieldAttributes(
        prefixIcon: Icon(Icons.email_rounded, color: ColorTheme.borderColor),
        contentPadding: EdgeInsets.all(8),
        controller: email,
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
              controller: password,
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

  // Sign-in button
  Widget _buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: InputFormButton(
        key: const Key(WidgetsKeys.tSigninKey),
        attributes: TextFormButtonAttributes(
          onClick: () {
            if (_formKey.currentState!.validate()) {
              context.read<SignInBloc>().add(
                    SignInButtonEvent(
                      params: SignInParams(
                        email: email.text.trim(),
                        password: password.text.trim(),
                      ),
                    ),
                  );
            }
          },
          color: ColorTheme.secondary,
          titleColor: Colors.white,
          buttonWidthHeight: Size(double.maxFinite, 50),
          titleText: StringConstant.login,
          cornerRadius: 8,
        ),
      ),
    );
  }

  // Build sign-up prompt at the bottom
  Widget _buildSignUpPrompt(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringConstant.dontHaveAccount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorTheme.borderColor,
                  ),
            ),
            GestureDetector(
              onTap: () {
                context.push(GoRouterPaths.signupRoute);
              },
              child: Text(
                StringConstant.register,
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
