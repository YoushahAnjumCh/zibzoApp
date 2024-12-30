import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zibzo/features/zibzo/data/models/cart/cart_response_model.dart';
import '../../../../../fixture_reader/fixture_reader.dart';

void main() {
  group('CartResponseModel', () {
    test('should parse JSON correctly', () async {
      // Arrange
      final jsonString = fixture('cart/cart_response.json');

      // Act
      final model = CartResponseModel.fromJson(json.decode(jsonString));

      // Assert
      expect(model.products.length, 1);
      expect(model.cartProductCount, 1);
      expect(model.products.first.title, 'Women Overcoat');
    });

    test('should handle empty lists gracefully', () async {
      // Arrange
      const emptyJson = '''
      {
        "products": [],
        "cartProductCount": 0
      }
      ''';

      // Act
      final model = CartResponseModel.fromJson(json.decode(emptyJson));

      // Assert
      expect(model.products, isEmpty);
      expect(model.cartProductCount, 0);
    });

    test('should throw an exception for missing required fields', () async {
      // Arrange
      const invalidJson = '''
      {
        "products": []
      }
      ''';

      // Act & Assert
      expect(
        () => CartResponseModel.fromJson(json.decode(invalidJson)),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
