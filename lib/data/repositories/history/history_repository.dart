import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/recharge_history_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class HistoryRepository {
  final ApiClientRepository api;

  HistoryRepository(this.api);

  Future<List<RechargeHistory>> loadRechargesHistory() async {
    try {
      developer.log(
        "Loading recharges history from api",
        name: "loadRechargesHistory",
      );

      final response = await api.get(
        "${ApiUrls.rechargeUrl}?page_size=100",
        logName: "loadRechargesHistory",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load sales: ${response.statusCode} - ${response.body}",
          name: "loadRechargesHistory",
        );

        throw Exception("error_loading_recharges");
      }

      final userType = api.sessionRepository.session?.userType;
      final studentId = api.sessionRepository.session?.userId;

      List<dynamic> body = json.decode(
        utf8.decode(response.bodyBytes),
      )["results"];

      final List<RechargeHistory> rechargeHistory = [];

      developer.log("Recharge body $body ", name: "loadRechargesHistory");
      if (userType == UserRole.tutor || userType == UserRole.teacher) {
        for (dynamic historyElement in body) {
          rechargeHistory.add(RechargeHistory.fromJson(historyElement));
        }
      } else if (userType == UserRole.student) {
        for (dynamic historyElement in body) {
          if (historyElement["user_recharger"]["instance"]["id"].toString() ==
              studentId.toString()) {
            rechargeHistory.add(RechargeHistory.fromJson(historyElement));
          }
        }
      }

      return rechargeHistory;
    } catch (e) {
      developer.log(
        "Failed to load cafeterias: $e",
        name: "loadRechargesHistory",
      );
      throw Exception("error_loading_recharges");
    }
  }
}
