import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/alergy_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class AlergyRepository {
  final ApiClientRepository api;

  AlergyRepository(this.api);

  Future<List<Alergy>> loadAlergies() async {
    List<Alergy> allAlergies = [];
    String? nextUrl = ApiUrls.alergiesUrl;
    int pageNumber = 1;

    try {
      while (nextUrl != null) {
        final response = await api.get(
          nextUrl,
          logName: "loadAlergys_page_$pageNumber",
        );

        if (response.statusCode != 200) {
          developer.log(
            "Failed to load Alergys page $pageNumber: ${response.statusCode} - ${response.body}",
            name: "loadAlergys",
          );
          throw Exception("error_loading_Alergys");
        }

        final decodedBody =
            json.decode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>;

        final List<dynamic> results = decodedBody["results"];

        for (var item in results) {
          allAlergies.add(Alergy.fromJson(item));
        }

        nextUrl = decodedBody["next"];
        pageNumber++;
      }

      developer.log(
        "Finished loading all Alergys. Total: ${allAlergies.length}",
        name: "loadAlergys",
      );

      return allAlergies;
    } catch (e) {
      developer.log("Error loading Alergys: $e", name: "loadAlergys", error: e);
      throw Exception("error_loading_Alergys");
    }
  }
}
