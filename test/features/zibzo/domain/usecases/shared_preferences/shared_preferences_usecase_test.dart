import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/features/zibzo/domain/usecases/shared_preferences/shared_preferences_usecase.dart';

// Mock class for AppLocalStorage
class MockAppLocalStorage extends Mock implements AppLocalStorage {}

void main() {
  late MockAppLocalStorage mockLocalStorage;
  late SharedPreferencesLoginUseCase loginUseCase;
  late SharedPreferencesLoginStatusUseCase loginStatusUseCase;
  late SharedPreferencesLogoutUseCase logoutUseCase;

  setUp(() {
    mockLocalStorage = MockAppLocalStorage();
    loginUseCase = SharedPreferencesLoginUseCase(mockLocalStorage);
    loginStatusUseCase = SharedPreferencesLoginStatusUseCase(mockLocalStorage);
    logoutUseCase = SharedPreferencesLogoutUseCase(mockLocalStorage);
  });

  group('SharedPreferencesLoginUseCase', () {
    test("Should call saveToken on AppLocalStorage when logging in", () async {
      // Arrange
      when(() => mockLocalStorage.saveToken("username"))
          .thenAnswer((_) async => Future.value(null));

      // Act
      await loginUseCase.logIn("username", "key");

      // Assert
      verify(() => mockLocalStorage.saveToken("username")).called(1);
    });
  });

  group('SharedPreferencesLoginStatusUseCase', () {
    test("Should return true if user is logged in", () async {
      // Arrange
      when(() => mockLocalStorage.isLoggedIn()).thenAnswer((_) async => true);

      // Act
      final result = await loginStatusUseCase.isLoggedIn();

      // Assert
      expect(result, true);
      verify(() => mockLocalStorage.isLoggedIn()).called(1);
    });

    test("Should return false if user is not logged in", () async {
      // Arrange
      when(() => mockLocalStorage.isLoggedIn()).thenAnswer((_) async => false);

      // Act
      final result = await loginStatusUseCase.isLoggedIn();

      // Assert
      expect(result, false);
      verify(() => mockLocalStorage.isLoggedIn()).called(1);
    });
  });

  group('SharedPreferencesLogoutUseCase', () {
    test("Should call clearToken on AppLocalStorage when logging out",
        () async {
      // Arrange
      when(() => mockLocalStorage.clearToken())
          .thenAnswer((_) async => Future.value(null));

      // Act
      await logoutUseCase.logOut("key");

      // Assert
      verify(() => mockLocalStorage.clearToken()).called(1);
    });
  });
}
