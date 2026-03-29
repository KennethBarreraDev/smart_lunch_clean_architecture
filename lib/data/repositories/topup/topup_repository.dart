import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/topup_responses.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class TopupRepository {
  final ApiClientRepository api;

  TopupRepository(this.api);

  Future<Map<String, dynamic>> topupBalance({
    required String userBuyer,
    required String amount,
    required AllowedTopupMethods selectedMethod,
    String? cardId,
    String? deviceSessionID,
    String? cvv,
    String? tokenizedCard,
  }) async {
    try {
      developer.log(
        "Incrementing balance by amount $amount",
        name: "topupBalance",
      );

      final parsedAmount = double.tryParse(amount);
      if (parsedAmount == null || parsedAmount >= 10000) {
        return _error();
      }

      final body = _buildRequestBody(
        method: selectedMethod,
        userBuyer: userBuyer,
        amount: amount,
        cardId: cardId,
        deviceSessionID: deviceSessionID,
        cvv: cvv,
        tokenizedCard: tokenizedCard,
      );

      final response = await api.post(ApiUrls.rechargeUrl, body, logName: "topupBalance");

      if (response.statusCode != 201) {
        return _error();
      }

      final responseMap = json.decode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      developer.log("Response: $responseMap", name: "topupBalance");

      return _handleResponse(selectedMethod, responseMap);
    } catch (e) {
      developer.log("Topup error: $e", name: "topupBalance");
      return _error();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required AllowedTopupMethods method,
    required String userBuyer,
    required String amount,
    String? cardId,
    String? deviceSessionID,
    String? cvv,
    String? tokenizedCard,
  }) {
    switch (method) {
      case AllowedTopupMethods.openpay:
        return {
          "amount": amount,
          "user_recharger": userBuyer,
          "payment_method": "OPENPAY",
          "card_id": cardId,
          "device_session_id": deviceSessionID,
        };

      case AllowedTopupMethods.mercadoPago:
        return {
          "recharge_date": DateTime.now().toUtc().toIso8601String(),
          "amount": amount,
          "user_recharger": userBuyer,
          "payment_method": "MERCADO_PAGO",
        };

      case AllowedTopupMethods.croem:
      case AllowedTopupMethods.yappi:
        return {
          "amount": amount,
          "cvv": cvv,
          "user_recharger": userBuyer,
          "tokenized_card": tokenizedCard,
          "current_card": cardId,
          "payment_method": "CROEM",
        };
    }
  }

  Map<String, dynamic> _handleResponse(
    AllowedTopupMethods method,
    Map<String, dynamic> response,
  ) {
    switch (method) {
      case AllowedTopupMethods.openpay:
        return _handleOpenpay(response);

      case AllowedTopupMethods.mercadoPago:
        return {
          "status": TopupResponses.openMercadoPago,
          "mercado_pago_url":
              response['mercadopago_preference']?["preference_url"] ?? "",
        };

      case AllowedTopupMethods.croem:
        return {
          "status": TopupResponses.regularCroemResponse,
          "rechargeFolio": response["folio"] ?? "",
          "platformFolio":
              response["croem_recharge"]?["transaction_croem_id"] ?? "",
          "transactionStatus":
              response["status"]?.toString().toUpperCase() ?? "",
        };

      case AllowedTopupMethods.yappi:
        return {
          "status": TopupResponses.openYappi,
          "yappi_url": response["url"] ?? "",
        };
    }
  }

  Map<String, dynamic> _handleOpenpay(Map<String, dynamic> response) {
    final hasId = response.containsKey("id");

    if (hasId) {
      return {
        "status": TopupResponses.regularOpenpayResponse,
        "rechargeFolio": response["folio"] ?? "",
        "platformFolio":
            response["openpay_recharge"]?["transaction_openpay_id"] ?? "",
        "transactionStatus":
            response["status"]?.toString().toUpperCase() ?? "",
      };
    }

    return {
      "status": TopupResponses.open3dSecure,
      "3d_secure_url":
          response["openpay_recharge"]?["url_three_d_secure"] ?? "",
    };
  }

  Map<String, dynamic> _error() {
    return {"status": TopupResponses.error};
  }
}