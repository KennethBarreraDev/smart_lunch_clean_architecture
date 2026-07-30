import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/ingredients_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class IngredientRepository {
  final ApiClientRepository api;

  IngredientRepository(this.api);

  Future<List<Ingredient>> loadIngredients({ required int cafeteriaId }) async {
    List<Ingredient> allIngredients = [];
    String? nextUrl = ApiUrls.ingredientsUrl;
    int pageNumber = 1;


    try {
      while (nextUrl != null) {
        final response = await api.get(
          nextUrl,
          logName: "loadIngredients_page_$pageNumber",
        );

        if (response.statusCode != 200) {
          developer.log(
            "Failed to load ingredients page $pageNumber: ${response.statusCode} - ${response.body}",
            name: "loadIngredients",
          );
          throw Exception("error_loading_ingredients");
        }

        final decodedBody =
            json.decode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>;

        final List<dynamic> results = decodedBody["results"];

        for (var item in results) {
          if( item["cafeteria"] == cafeteriaId ) {
            allIngredients.add(Ingredient.fromJson(item));
          }          
        }

        nextUrl = decodedBody["next"];
        pageNumber++;
      }

      developer.log(
        "Finished loading all ingredients. Total: ${allIngredients.length}",
        name: "loadIngredients",
      );

      return allIngredients;
    } catch (e) {
      developer.log(
        "Error loading ingredients: $e",
        name: "loadIngredients",
        error: e,
      );
      throw Exception("error_loading_ingredients");
    }
  }
}
