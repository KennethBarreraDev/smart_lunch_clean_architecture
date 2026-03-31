import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/memberships_payments_response.dart';
import 'package:smart_lunch/core/utils/topup_responses.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class MembershipsRepository {
  final ApiClientRepository api;

  MembershipsRepository(this.api);

  Future<Map<String, dynamic>> payMemberships({
    Map<int, int>? memberships,
    AllowedPaymentMethods? selectedMethod,
    String? cardID,
    String? cvv,
  }) async {
    try {
      List<Map<String, dynamic>> membershipsToPay = (memberships ?? {}).entries
          .map((entry) {
            return {"student": entry.key, "months": entry.value};
          })
          .toList();

      Map<String, dynamic> body = {"students": membershipsToPay};

      if (selectedMethod == AllowedPaymentMethods.croem) {
        body = {
          ...body,
          "payment_method": "CROEM",
          "croem": {"card_id": cardID, "cvv": cvv},
        };
      } else {
        body = {...body, "payment_method": "YAPPY"};
      }

      final response = await api.post(
        ApiUrls.membershipsUrl,
        body,
        logName: "payMemberships",
      );

      if (response.statusCode != 200) {
        return _error();
      }

      final responseMap =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      developer.log("Response: $responseMap", name: "payMemberships");

      return _handleResponse(selectedMethod!, responseMap);
    } catch (e) {
      developer.log("Topup error: $e", name: "payMemberships");
      return _error();
    }
  }

  Map<String, dynamic> _handleResponse(
    AllowedPaymentMethods method,
    Map<String, dynamic> response,
  ) {
    switch (method) {
      case AllowedPaymentMethods.croem:
        return {
          "status": MembershipsPaymentResponses.regularCroemResponse,
          "transactionStatus":
              response["status"]?.toString().toUpperCase() ?? "",
        };

      case AllowedPaymentMethods.yappi:
        return {
          "status": TopupResponses.openYappi,
          "yappi_url": response["url"] ?? "",
        };
      default:
        return _error();
    }
  }


  Map<String, dynamic> _error() {
    return {"status": MembershipsPaymentResponses.error};
  }
}
