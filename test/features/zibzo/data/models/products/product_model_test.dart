import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zibzo_app/features/zibzo/data/models/products/product_model.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';

import '../../../../../fixture_reader/fixture_reader.dart';
import '../../../../constants/product_params.dart';

void main() {
  test("should be sub class ProductModel ", () async {
    expect(tProductModel, isA<Products>());
  });

  group("from Json", () {
    test("productModel fromJson", () async {
      final result = ProductModel.fromJson(
          json.decode(fixture('/products/products_mocks.json')));

      expect(result, tProductModel);
    });
  });

  group("toJson", () {
    test("productModel toJson", () async {
      final result = tProductModel.toJson();

      final Map<String, dynamic> productModelfromJson =
          json.decode(fixture('/products/products_mocks.json'));
      expect(result, productModelfromJson);
    });
  });
}
