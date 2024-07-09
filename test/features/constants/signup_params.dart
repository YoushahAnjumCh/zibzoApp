import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/signup/signup_usecase.dart';

const tSignUpParams = SignUpParams(
    email: "email",
    firstName: "firstname",
    lastName: "lastName",
    password: "password");

const tUserModel = UserModel(
    id: "6614938b95a5d403caa6628f",
    firstName: "John",
    token: "token",
    lastName: "Doe",
    email: "john.doe@example.com");

const tUser =
    User(id: "1", firstName: "firstName", lastName: "lastName", email: "email");
