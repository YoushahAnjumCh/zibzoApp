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
      expect(model.products.first.productName, 'Women Overcoat');
    });

    test('should serialize to JSON correctly', () async {
      // Arrange
      final jsonString = fixture('cart/cart_response.json');

      final model = CartResponseModel.fromJson(json.decode(jsonString));

      // Act
      final serializedJson = model.toJson();

      // Assert
      expect(serializedJson['products'].length, 1);
      expect(serializedJson['cartProductCount'], 1);
    });
  });
}
