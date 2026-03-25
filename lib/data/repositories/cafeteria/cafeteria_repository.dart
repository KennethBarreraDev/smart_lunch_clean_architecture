import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class CafeteriaRepository {
  final ApiClientRepository api;

  CafeteriaRepository(this.api);

  Future<List<Cafeteria>> loadCafeterias() async {
    try {
      developer.log("Loading cafeterias from API", name: "loadCafeterias");

      final response = await api.get(ApiUrls.cafeteriaUrl, logName: "loadCafeterias");

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load cafeterias: ${response.statusCode} - ${response.body}",
          name: "loadCafeterias",
        );
        throw Exception("error_loading_cafeterias");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      developer.log("Loaded cafeterias: $decoded", name: "loadCafeterias");

      List<dynamic> cafeterias = decoded["results"];

      return cafeterias.map((e) => Cafeteria.fromJson(e)).toList();
    } catch (e) {
      developer.log(
        "Failed to load cafeterias: $e",
        name: "loadCafeterias",
      );
      throw Exception("error_loading_cafeterias");
    }
  }

  Future<CafeteriaSetting> loadCafeteriaSettings(String cafeteriaId) async {
    try {
      developer.log(
        "Loading settings from cafeteria $cafeteriaId",
        name: "loadCafeteriaSettings",
      );

      final response = await api.get(
        "${ApiUrls.cafeteriaSettingsUrl}/$cafeteriaId",
        logName: "loadCafeteriaSettings",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load settings: ${response.statusCode} - ${response.body}",
          name: "loadCafeteriaSettings",
        );
        throw Exception("error_loading_cafeterias_settings");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      developer.log(
        "Loaded cafeteria settings: $decoded",
        name: "loadCafeteriaSettings",
      );

      //TODO: Ask for settings
      CafeteriaSetting cafeteriaSettings = CafeteriaSetting.fromJson([decoded]);

      return cafeteriaSettings;
    } catch (e) {
      developer.log("Failed to load settings: $e", name: "loadCafeteriaSettings");
      throw Exception("error_loading_cafeterias_settings");
    }
  }
}
