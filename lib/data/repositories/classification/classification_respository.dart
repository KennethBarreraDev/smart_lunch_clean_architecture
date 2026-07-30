import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/classification_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class ClassificationRepository {
  final ApiClientRepository api;

  ClassificationRepository(this.api);

  Future<List<Classification>> loadClassifications() async {
    List<Classification> allClassifications = [];
    String? nextUrl = ApiUrls.classificationUrl;
    int pageNumber = 1;

    try {
      while (nextUrl != null) {
        final response = await api.get(
          nextUrl,
          logName: "loadClassifications_page_$pageNumber",
        );

        if (response.statusCode != 200) {
          developer.log(
            "Failed to load classifications page $pageNumber: ${response.statusCode} - ${response.body}",
            name: "loadClassifications",
          );
          throw Exception("error_loading_classifications");
        }

        final decodedBody =
            json.decode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>;

        final List<dynamic> results = decodedBody["results"];

        for (var item in results) {
          allClassifications.add(Classification.fromJson(item));
        }

        nextUrl = decodedBody["next"];
        pageNumber++;
      }

      developer.log(
        "Finished loading all classifications. Total: ${allClassifications.length}",
        name: "loadClassifications",
      );

      return allClassifications;
    } catch (e) {
      developer.log(
        "Error loading classifications: $e",
        name: "loadClassifications",
        error: e,
      );
      throw Exception("error_loading_classifications");
    }
  }
}
