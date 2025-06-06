import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:zibzo/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo/features/zibzo/domain/entities/signup/user.dart';
import '../../../../fixture_reader/fixture_reader.dart';
import '../../../constants/signup_params.dart';

void main() {
  test('should be a sub class of User Entity', () {
    expect(tUserModel, isA<User>());
  });

  test(
    'should return success user from Map',
    () async {
      /// Arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('user/user_mocks.json'));

      /// Act
      final result = UserModel.fromJson(jsonMap);

      /// Assert
      expect(result, equals(tUserModel));
    },
  );

  test(
    'should return a JSON map containing the proper data',
    () async {
      /// Act
      final result = tUserModel.toJson();

      /// Assert
      final expectedMap = {
        "email": "john.doe@example.com",
        "userName": "Doe",
        "id": "6614938b95a5d403caa6628f",
        "token": "token",
        "image":
            "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"
      };
      expect(result, expectedMap);
    },
  );
}
