import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zibzo_app/features/zibzo/data/models/products/product_response_model.dart';

import '../../../../../fixture_reader/fixture_reader.dart';

void main() {
  group('ProductResponseModel', () {
    test('should parse JSON correctly', () async {
      // Arrange
      final jsonString = fixture('products/home_page_products.json');

      // Act
      final model = ProductResponseModel.fromJson(json.decode(jsonString));

      // Assert
      expect(model.products.length, 8);
      expect(model.products.first.title, 'Crewneck Mixed Texture');
      expect(model.homebanner.length, 4);
      expect(model.category.length, 3);
      expect(model.offerbanner.length, 1);
    });

    test('homeResponseModelFromJson should correctly parse JSON string',
        () async {
      // Arrange: Load the mock JSON string
      final jsonString = fixture('products/home_page_products.json');

      // Act: Convert the JSON string to a ProductResponseModel object
      final model = homeResponseModelFromJson(jsonString);

      // Assert: Check that the data is parsed correctly
      expect(model.products.length, 8);
      expect(model.products.first.title, 'Crewneck Mixed Texture');
      expect(model.homebanner.length, 4);
      expect(model.category.length, 3);
      expect(model.offerbanner.length, 1);
    });

    test(
        'homeResponseModelToJson should correctly serialize ProductResponseModel',
        () async {
      // Arrange: Load the mock JSON string and parse it into a ProductResponseModel
      final jsonString = fixture('products/home_page_products.json');

      final model = homeResponseModelFromJson(jsonString);

      // Act: Convert the ProductResponseModel back to JSON
      final serializedJson = homeResponseModelToJson(model);

      // Assert: Check that the serialized JSON matches the expected structure
      final decodedJson = json.decode(serializedJson);

      expect(decodedJson['products'].length, 8);
      expect(decodedJson['homebanner'].length, 4);
      expect(decodedJson['category'].length, 3);
      expect(decodedJson['offerbanner'].length, 1);
    });

    test('should serialize to JSON correctly', () async {
      // Arrange
      final jsonString = fixture('products/home_page_products.json');

      final model = ProductResponseModel.fromJson(json.decode(jsonString));

      // Act
      final serializedJson = model.toJson();

      // Assert
      expect(serializedJson['products'].length, 8);
      expect(serializedJson['homebanner'].length, 4);
      expect(serializedJson['category'].length, 3);
      expect(serializedJson['offerbanner'].length, 1);
    });

    test('should handle empty lists gracefully', () async {
      // Arrange
      const emptyJson = '''
      {
        "products": [],
        "homebanner": [],
        "category": [],
        "offerbanner": [],
        "cartProductCount:": 0
      }
      ''';

      // Act
      final model = ProductResponseModel.fromJson(json.decode(emptyJson));

      // Assert
      expect(model.products, isEmpty);
      expect(model.homebanner, isEmpty);
      expect(model.category, isEmpty);
      expect(model.offerbanner, isEmpty);
      expect(model.cartProductCount, 0);
    });
  });
}
