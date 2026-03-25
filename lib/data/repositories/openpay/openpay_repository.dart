import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class OpenpayRepository {
  final ApiClientRepository api;

  OpenpayRepository(this.api);

  Future<void> createOpenPayCustomer() async {
    try {
      developer.log("Creating openpay customer", name: "createOpenPayCustomer");

      final response = await api.get(
        ApiUrls.openpayCustomer,
        logName: "createOpenPayCustomer",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to create openpay customer: ${response.statusCode} - ${response.body}",
          name: "createOpenPayCustomer",
        );
        throw Exception("error_creating_openpay_customer");
      }

      Map<String, dynamic> responseMap = json.decode(
        utf8.decode(response.bodyBytes),
      );
      developer.log(
        "Response map: $responseMap",
        name: "createOpenPayCustomer",
      );
    } catch (e) {
      developer.log(
        "Failed to load cafeterias: $e",
        name: "createOpenPayCustomer",
      );
    }
  }

  Future<Map<String, dynamic>?> getOpenPayCredentials() async {
    try {
      developer.log(
        "Getting OpenPay credentials",
        name: "getOpenPayCredentials",
      );

      final response = await api.get(
        ApiUrls.openPayCredentialsUrl,
        logName: "getOpenPayCredentials",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load OpenPay credentials: ${response.body}",
          name: "getOpenPayCredentials",
        );
        throw Exception("error_loading_openpay_credentials");
      }

      final responseMap =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      developer.log(
        "Response map: $responseMap",
        name: "getOpenPayCredentials",
      );

      return responseMap;
    } catch (e) {
      developer.log(
        "Error getting OpenPay credentials: $e",
        name: "getOpenPayCredentials",
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTutorOpenPayAccount() async {
    try {
      developer.log("Get tutor info start", name: "getTutorOpenPayAccount");

      final response = await api.get(
        ApiUrls.openPayTutorUrl,
        logName: "getTutorOpenPayAccount",
      );

      if (response.statusCode != 200) {
        developer.log(response.body.toString(), name: "getTutorOpenPayAccount");
        throw Exception("getTutorOpenPayAccount");
      }

      final responseMap =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      developer.log(responseMap.toString(), name: "getTutorOpenPayAccount");

      return responseMap;
    } catch (e) {
      developer.log(
        "Error getting tutor OpenPay account: $e",
        name: "getTutorOpenPayAccount",
      );
      rethrow;
    }
  }
}
