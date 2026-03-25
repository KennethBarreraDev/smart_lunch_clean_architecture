import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class FamlilyRepository {
  final ApiClientRepository api;

  FamlilyRepository(this.api);

  Future<double> loadFamily() async {
    try {
      developer.log("Loading user family from API", name: "loadFamily");

      final response = await api.get(
        "${ApiUrls.familyUrl}${api.sessionRepository.session?.familyId}",
        logName: "loadFamily",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load family: ${response.statusCode} - ${response.body}",
          name: "loadFamily",
        );
        //TODO: Ask for error in response
        return 1000;
        throw Exception("error_loading_family");
      }

      Map<String, dynamic> responseMap = json.decode(
        utf8.decode(response.bodyBytes),
      );
      developer.log(
        "Response map: $responseMap",
        name: "loadFamily",
      );


      return responseMap["results"][0]["balance"] ?? "0.00";
    } catch (e) {
      developer.log("Failed to load cafeterias: $e", name: "loadFamily");
      throw Exception("error_loading_family");
    }
  }
}
