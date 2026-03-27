import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class OpenpayRepository {
  final ApiClientRepository api;
  final _sandboxUrl = "https://sandbox-api.openpay.mx/v1/";
  final _productionUrl = "https://api.openpay.mx/v1/";

  String get _merchantBaseUrl => '$baseUrl/v1/';

  String get baseUrl => ApiUrls.developmentMode ? _productionUrl : _sandboxUrl;

  OpenpayRepository(this.api);

  Future<String> getDeviceSessionId() async {
    try {
      return await Openpay.openpayPlatform.invokeMethod('getDeviceSessionId');
    } catch (e) {
      developer.log(
        "Error getting device session id: $e",
        name: "openpay_provider",
      );
      return "";
    }
  }

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

  Future<List<OpenpayCard>> getCards() async {
    try {
      List<OpenpayCard> cards = [];
      int internalId = 0;

      developer.log("Get cards start", name: "getCards");

      final response = await api.get(
        ApiUrls.openPayCardsUrl,
        logName: "getCards",
      );

      if (response.statusCode != 200) {
        developer.log(response.body.toString(), name: "getCards");
        throw Exception("getCards");
      }

      for (dynamic card in json.decode(
        utf8.decode(response.bodyBytes),
      )["data"]) {
        cards.add(OpenpayCard.fromBackend(card, internalId));
        internalId += 1;
      }
      developer.log(cards.toString(), name: "getCards");

      return cards;
    } catch (e) {
      developer.log("Error getting cards: $e", name: "getCards");
      rethrow;
    }
  }

  Future<OpenpayCard> registerOpenpayCard({
    required String holderName,
    required String cardNumber,
    required String cvv2,
    required String expirationMonth,
    required String expirationYear,
    required int internalId,
    required String deviceSessionId,
    required Openpay openpay,
  }) async {
    try {
      String basicAuth =
          'Basic ${base64.encode(utf8.encode("${openpay.apiKey}:"))}';
      final openpayResponse = await api.post(
        "$_merchantBaseUrl/${openpay.merchantId}/tokens/",
        {
          "holder_name": holderName,
          "card_number": cardNumber,
          "cvv2": cvv2,
          "expiration_month": expirationMonth,
          "expiration_year": expirationYear,
          "device_session_id": deviceSessionId,
        },
        headers: {"Authorization": basicAuth},
        logName: "registerOpenpayCard",
      );

      if (openpayResponse.statusCode != 201) {
        developer.log(
          openpayResponse.body.toString(),
          name: "registerOpenpayCard",
        );
        throw Exception("registerOpenpayCard");
      }

      String tokenId = jsonDecode(openpayResponse.body)["id"];

      final response = await api.post(ApiUrls.openPayCardsUrl, {
        "card_token_id": tokenId,
        "device_session_id": deviceSessionId,
      }, logName: "registerOpenpayCard");
      if (response.statusCode != 200) {
        developer.log(response.body.toString(), name: "registerOpenpayCard");
        throw Exception("registerOpenpayCard");
      }

      final OpenpayCard card = OpenpayCard.fromBackend(
        json.decode(response.body),
        internalId,
      );

      return card;
    } catch (e) {
      developer.log("Error registering card: $e", name: "registerOpenpayCard");
      rethrow;
    }
  }
}
