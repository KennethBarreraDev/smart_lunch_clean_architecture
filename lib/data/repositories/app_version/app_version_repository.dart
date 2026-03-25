import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/app_version_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class AppVersionRepository {
  final ApiClientRepository api;

  AppVersionRepository(this.api);

  Future<AppVersion> getLastAppVersion() async {
    developer.log("Getting last app version", name: "getLastAppVersion");

    final response = await api.get(ApiUrls.appVersionUrl, logName: "getLastAppVersion");

    if (response.statusCode != 200) {
      developer.log(
        "Failed to load app version: ${response.statusCode} - ${response.body}",
        name: "getLastAppVersion",
      );
      throw Exception("error_loading_cafeterias_settings");
    }
    Map<String, dynamic> responseMap = json.decode(
      utf8.decode(response.bodyBytes),
    );
    developer.log("Response $responseMap", name: "getLastAppVersion");
    AppVersion appVersion = AppVersion.fromJson(responseMap["results"]);
    return appVersion;
  }
}
