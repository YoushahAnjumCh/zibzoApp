import 'dart:io';

import 'package:zibzo_app/core/constant/assets_path.dart';
import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';

final tSignUpParams = SignUpParams(
    email: "sample@gmail.com",
    userName: "userName",
    password: "password",
    selectedImage: File(AssetsPath.appLogo));

const tUserModel = UserModel(
    email: "john.doe@example.com",
    userName: "Doe",
    id: "6614938b95a5d403caa6628f",
    token: "token",
    image:
        "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png");

const tUser = User(
    id: "1",
    email: "email",
    userName: "userName",
    image: "image",
    token: "token");
