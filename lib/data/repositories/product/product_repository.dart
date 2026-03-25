import 'dart:convert';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/product_category_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class ProductsRepository {
  final ApiClientRepository api;

  ProductsRepository(this.api);

  Future<List<ProductCategory>> loadCategories(
   
  ) async {
    try {
      final response = await api.get(
        ApiUrls.categoriesUrl,
        logName: "loadCategories",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load categories: ${response.statusCode} - ${response.body}",
          name: "loadCategories",
        );

        throw Exception("error_loading_categories");
      }

      List<dynamic> body = json.decode(
        utf8.decode(response.bodyBytes),
      )["results"];

      developer.log("Categories response $body", name: "loadCategories");

      List<ProductCategory> categories = [];

      for (dynamic product in body) {
        categories.add(ProductCategory.fromJson(product));
      }

      return categories;
    } catch (e) {
      developer.log("Failed to load cafeterias: $e", name: "loadCategories");
      throw Exception("error_loading_categories");
    }
  }

 

  Future<List<ProductModel>> loadProducts(
    Cafeteria cafeteria, {
    DateTime? userSelectedDate,
    bool omitFilters = true,
    bool isPresale = false,
  }) async {
    try {

      developer.log("Loading products from api ", name: "loadProducts");

      DateTime utcDateTime = userSelectedDate ?? DateTime.now().toUtc();
      DateTime customUtcDateTime = DateTime.utc(
        utcDateTime.year,
        utcDateTime.month,
        utcDateTime.day,
        6,
        0,
        0,
        0,
        0, // Establecer la hora a 06:00:00.000
      );

      String formattedDate = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      ).format(customUtcDateTime);

      DateTime now = userSelectedDate ?? DateTime.now();
      String dayOfWeek = DateFormat('EEE').format(now).toUpperCase();

      String saleChannel = isPresale ? 'ONLINE_PRESALES' : 'ONLINE_SALES';
      int pageSize = 1000;
      int currentPage = 1;
      String cafeteriaId = cafeteria.id.toString();

      final baseUrl =
          "${ApiUrls.productsUrl}?page_size=$pageSize&page=$currentPage&cafeteria=$cafeteriaId";

      final String url = omitFilters
          ? baseUrl
          : "$baseUrl&available_day=$formattedDate,$dayOfWeek&sales_channel=$saleChannel";
      
      final response = await api.get(url, logName: "loadProducts");

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load products: ${response.statusCode} - ${response.body}",
          name: "loadProducts",
        );

        throw Exception("error_loading_products");
      }

      List<dynamic> body = json.decode(
        utf8.decode(response.bodyBytes),
      )["results"];

      developer.log("Products response $body", name: "loadProducts");

      List<ProductModel> products = [];

      for (dynamic product in body) {
        products.add(ProductModel.fromJson(product));
      }

      return products;
    } catch (e) {
      developer.log("Failed to load cafeterias: $e", name: "loadProducts");
      throw Exception("error_loading_products");
    }
  }
}
