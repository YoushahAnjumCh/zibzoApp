import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';

const tSignUpParams = SignUpParams(
    email: "email@gmail.com", userName: "userName", password: "password");

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
