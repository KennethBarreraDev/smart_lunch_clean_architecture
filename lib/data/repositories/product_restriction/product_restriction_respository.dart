import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/product_restrictiction_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class ProductRestrictionRepository {
  final ApiClientRepository api;

  ProductRestrictionRepository(this.api);

  Future<List<ProductRestriction>> loadProductRestrictions({
    required int studentId,
  }) async {
    List<ProductRestriction> allRestrictions = [];
    String? nextUrl = ApiUrls.productRestrictionUrl;
    int pageNumber = 1;

    try {
      while (nextUrl != null) {
        final response = await api.get(
          nextUrl,
          logName: "loadProductRestrictions_page_$pageNumber",
        );

        if (response.statusCode != 200) {
          developer.log(
            "Failed to load product restrictions page $pageNumber: ${response.statusCode} - ${response.body}",
            name: "loadProductRestrictions",
          );
          throw Exception("error_loading_product_restrictions");
        }

        final decodedBody =
            json.decode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>;

        final List<dynamic> results = decodedBody["results"];

        for (var item in results) {
          if (item["student"] == studentId) {
            allRestrictions.add(ProductRestriction.fromJson(item));
          }
        }

        nextUrl = decodedBody["next"];
        pageNumber++;
      }

      developer.log(
        "Finished loading all product restrictions. Total: ${allRestrictions.length}",
        name: "loadProductRestrictions",
      );

      return allRestrictions;
    } catch (e) {
      developer.log(
        "Error loading product restrictions: $e",
        name: "loadProductRestrictions",
        error: e,
      );
      throw Exception("error_loading_product_restrictions");
    }
  }

  Future<ProductRestriction> createProductRestriction({
    required int studentId,
    required int productId,
    required String restrictionType,
    int quantity = 1,
  }) async {
    try {
      final response = await api.post(ApiUrls.productRestrictionUrl, {
        "student": studentId,
        "product": productId,
        "restriction_type": restrictionType,
        "quantity": quantity < 1 ? 1 : quantity,
        "frequency": "daily",
      }, logName: "createProductRestriction");

      if (response.statusCode != 200 && response.statusCode != 201) {
        developer.log(
          "Failed to create product restriction: ${response.statusCode} - ${response.body}",
          name: "createProductRestriction",
        );
        throw Exception("error_creating_product_restriction");
      }

      final decodedBody =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      return ProductRestriction.fromJson(decodedBody);
    } catch (e) {
      developer.log(
        "Error creating product restriction: $e",
        name: "createProductRestriction",
        error: e,
      );
      throw Exception("error_creating_product_restriction");
    }
  }

  Future<ProductRestriction> updateRestrictionType({
    required int id,
    required String restrictionType,
  }) async {
    try {
      final response = await api.patch(
        "${ApiUrls.productRestrictionUrl}$id/",
        {"restriction_type": restrictionType},
        logName: "updateProductRestrictionType",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to update product restriction: ${response.statusCode} - ${response.body}",
          name: "updateProductRestrictionType",
        );
        throw Exception("error_updating_product_restriction");
      }

      final decodedBody =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      return ProductRestriction.fromJson(decodedBody);
    } catch (e) {
      developer.log(
        "Error updating product restriction: $e",
        name: "updateProductRestrictionType",
        error: e,
      );
      throw Exception("error_updating_product_restriction");
    }
  }

  Future<ProductRestriction> updateProductRestrictionLimit({
    required int id,
    required int quantity,
    required String restrictionType,
  }) async {
    try {
      final response = await api.patch(
        "${ApiUrls.productRestrictionUrl}$id/",
        {
          "quantity": quantity < 1 ? 1 : quantity,
          "restriction_type": restrictionType,
        },
        logName: "updateProductRestrictionLimit",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to update product restriction limit: ${response.statusCode} - ${response.body}",
          name: "updateProductRestrictionLimit",
        );
        throw Exception("error_updating_product_restriction");
      }

      final decodedBody =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      return ProductRestriction.fromJson(decodedBody);
    } catch (e) {
      developer.log(
        "Error updating product restriction limit: $e",
        name: "updateProductRestrictionLimit",
        error: e,
      );
      throw Exception("error_updating_product_restriction");
    }
  }
}
