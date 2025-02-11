import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:zibzo/common/image_picker_widget.dart';
import 'package:zibzo/common/password_notifier.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/constant/widgets_keys.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/core/validation/validation.dart';
import 'package:zibzo/features/zibzo/domain/usecases/signup/signup_usecase.dart';
import 'package:zibzo/features/zibzo/presentation/signup/bloc/signup_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/signup/bloc/signup_state.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/input_form_button.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>("");
  final ValueNotifier<File?> selectedImageNotifier = ValueNotifier<File?>(null);

  final _formKey = GlobalKey<FormState>();
  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

  late final ImagePickerWidget _imagePickerHandler;

  @override
  Widget build(BuildContext context) {
    _imagePickerHandler = ImagePickerWidget(selectedImageNotifier);
    AnalyticsService().logScreensView(
      'signup_screen',
      'SignUpScreen',
    );

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is UserLoading) {
          EasyLoading.show(
              status: "Loading", maskType: EasyLoadingMaskType.black);
          await Future.delayed(Duration(minutes: 1));
          EasyLoading.dismiss();
        } else if (state is UserLogged) {
          AnalyticsService().logSignUp();
          EasyLoading.dismiss();
          Navigator.pop(context);
        } else if (state is UserLoggedFail) {
          EasyLoading.dismiss();
          errorMessageNotifier.value = state.failure;
          Future.delayed(Duration(seconds: 5), () {
            errorMessageNotifier.value = "";
          });
        }
      },
      child: SafeArea(
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
                        _buildWelcomeText(context),
                        _buildErrorMessage(),
                        SizedBox(height: 40),
                        _buildProfilePicturePicker(context),
                        SizedBox(height: 20),
                        _buildSignInFields(context),
                        SizedBox(height: 20),
                        _buildSignInButton(context),
                        SizedBox(height: 20),
                        _buildSignInPrompt(context)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicturePicker(BuildContext context) {
    return ValueListenableBuilder<File?>(
      valueListenable: selectedImageNotifier,
      builder: (context, selectedImage, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () async {
                await _imagePickerHandler.pickImageFromGallery();
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    selectedImage != null ? FileImage(selectedImage) : null,
                child: selectedImage == null
                    ? Image.asset(AssetsPath.profileAvatar)
                    : null,
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: Icon(Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary))
          ],
        );
      },
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            StringConstant.letsMakeAccount,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

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
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildSignInFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _buildUserNameField(context),
          SizedBox(height: 20),
          _buildEmailField(context),
          SizedBox(height: 20),
          _buildPasswordField(),
          SizedBox(height: 20),
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  Widget _buildUserNameField(BuildContext context) {
    return InputTextFormField(
      key: const Key(WidgetsKeys.tUserNameKey),
      attributes: InputTextFormFieldAttributes(
        prefixIcon: Icon(Icons.person_2,
            color: Theme.of(context).colorScheme.onPrimaryContainer),
        contentPadding: EdgeInsets.all(18),
        controller: userNameController,
        hint: StringConstant.userName,
        hintColor: Theme.of(context).colorScheme.onPrimaryContainer,
        validation: FormValidator.validateNotEmpty,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return InputTextFormField(
      attributes: InputTextFormFieldAttributes(
        prefixIcon: Icon(Icons.email,
            color: Theme.of(context).colorScheme.onPrimaryContainer),
        contentPadding: EdgeInsets.all(18),
        controller: emailController,
        hint: StringConstant.email,
        hintColor: Theme.of(context).colorScheme.onPrimaryContainer,
        validation: FormValidator.validateEmail,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildPasswordField() {
    return ChangeNotifierProvider(
      create: (_) => PasswordVisibilityNotifier(),
      child: Consumer<PasswordVisibilityNotifier>(
        builder: (context, value, child) {
          return InputTextFormField(
            key: const Key(WidgetsKeys.tPasswordKey),
            attributes: InputTextFormFieldAttributes(
              prefixIcon: Icon(Icons.lock,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              passwordVisibilityNotifier: value,
              contentPadding: EdgeInsets.all(18),
              controller: passwordController,
              hintColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
            attributes: InputTextFormFieldAttributes(
              prefixIcon: Icon(Icons.lock,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              passwordVisibilityNotifier: value,
              contentPadding: EdgeInsets.all(18),
              controller: confirmPasswordController,
              hintColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
            cornerRadius: 30,
            buttonWidthHeight: const Size(double.maxFinite, 50),
            titleColor: Colors.white,
            titleText: StringConstant.signUp,
            color: Theme.of(context).colorScheme.primary,
            onClick: () {
              if (_formKey.currentState!.validate()) {
                File? selectedImage = selectedImageNotifier.value;
                if (passwordController.text != confirmPasswordController.text) {
                  errorMessageNotifier.value =
                      StringConstant.passwordConfirmError;
                  return;
                }
                context.read<UserBloc>().add(SignupUser(SignUpParams(
                      userName: userNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      selectedImage: selectedImage,
                    )));
              }
            }),
      ),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            StringConstant.alreadyHaveAccount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
          ),
          GestureDetector(
            onTap: () {
              context.push(GoRouterPaths.loginRoute);
            },
            child: Text(
              StringConstant.login,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
