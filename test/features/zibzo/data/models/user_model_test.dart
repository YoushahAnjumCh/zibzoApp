import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zibzo_app/features/zibzo/data/models/auth/user_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/signup/user.dart';

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
      final result = UserModel.fromMap(jsonMap);

      /// Assert
      expect(result, equals(tUserModel));
    },
  );

  test(
    'should return a JSON map containing the proper data',
    () async {
      /// Act
      final result = tUserModel.toMap();

      /// Assert
      final expectedMap = {
        "email": "john.doe@example.com",
        "firstName": "John",
        "lastName": "Doe",
        "_id": "6614938b95a5d403caa6628f",
        "token": "token"
      };
      expect(result, expectedMap);
    },
  );

  test(
    'should return success user from userModelFromJson',
    () async {
      /// Arrange
      final str = fixture('user/user_mocks.json');

      /// Act
      final result = userModelFromJson(str);

      /// Assert
      expect(result, equals(tUserModel));
    },
  );

  test(
    'should return success user from userModelToJson',
    () async {
      /// Arrange

      /// Act
      final result = userModelToJson(tUserModel);

      final expectedMap = {
        "_id": "6614938b95a5d403caa6628f",
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@example.com",
        "token": "token"
      };

      /// Assert
      expect(result, equals(json.encode(expectedMap)));
    },
  );
}
