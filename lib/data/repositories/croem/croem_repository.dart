import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/croem_card.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class CroemRepository {
  final ApiClientRepository api;

  CroemRepository(this.api);

  Future<List<CroemCard>> getCroemCards() async {
    try {
      List<CroemCard> cards = [];
      int internalId = 0;

      developer.log("Get cards start", name: "getCroemCards");

      final response = await api.get(
        ApiUrls.croemBaseUrl,
        logName: "getCroemCards",
      );

      if (response.statusCode != 200) {
        developer.log(response.body.toString(), name: "getCroemCards");
        throw Exception("getCroemCards");
      }

      for (dynamic card in json.decode(
        utf8.decode(response.bodyBytes),
      )["data"]) {
        cards.add(CroemCard.fromBackend(card, internalId));
        internalId += 1;
      }
      developer.log(cards.toString(), name: "getCroemCards");

      return cards;
    } catch (e) {
      developer.log("Error getting cards: $e", name: "getCroemCards");
      rethrow;
    }
  }

  Future<CroemCard> registerCroemCard(
    String tokenizedCard,
    String userID,
    String cardNumber,
    String cardHolderName,
    String identifierName,
    int currentCardIndex
  ) async {
    try {
      developer.log("Register card start", name: "registerCroemCard");

      Map<String, dynamic> requestBody = {
        "tokenized_card": tokenizedCard,
        "user": userID,
        "card_number": cardNumber,
        "card_holder_name": cardHolderName,
        "identifier_name": identifierName,
      };
      developer.log(requestBody.toString(), name: "registerCroemCard");
      final response = await api.post(
        ApiUrls.croemBaseUrl,
        requestBody,
        logName: "registerCroemCard",
      );

      developer.log(response.body.toString(), name: "registerCroemCard");

      if (response.statusCode != 200) {
        throw Exception("registerCroemCard");
      }
      developer.log("Register card end", name: "registerCroemCard");
      return CroemCard.fromBackend(json.decode(response.body), currentCardIndex);
    } catch (e) {
      developer.log("Error registering card: $e", name: "registerCroemCard");
      rethrow;
    }
  }
}
