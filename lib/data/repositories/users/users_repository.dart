import 'dart:convert';
import 'dart:developer' as developer;
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/debtors_response.dart';
import 'package:smart_lunch/data/models/user_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class UserRepository {
  final ApiClientRepository api;

  UserRepository(this.api);

  //TODO: Ask for a filter to load cafteria user by user ID
  Future<CafeteriaUser> loadCurrentUser() async {
    try {
      developer.log("Loading current user from API", name: "loadCurrentUser");

      final response = await api.get("${ApiUrls.cafeteriaUserUrl}?page_size=100");

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load users: ${response.statusCode} - ${response.body}",
          name: "loadCurrentUser",
        );
        throw Exception("error_loading_user");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      developer.log("Loaded user: $decoded", name: "loadCurrentUser");
      final List<CafeteriaUser> users = [];

      for (var user in decoded["results"]) {
        users.add(CafeteriaUser.fromJson(user));
      }
      return users.firstWhere(
        (user) => user.user?.id.toString() == api.sessionRepository.session?.userId,
      );
    } catch (e) {
      developer.log("Error loading user: $e", name: "loadCurrentUser");
      throw Exception("error_loading_user");
    }
  }

  Future<List<CafeteriaUser>> loadUserChildren() async {
    try {
      developer.log("Loading user children from API", name: "loadUserChildren");

      final response = await api.get(ApiUrls.cafeteriaUserUrl);

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load users: ${response.statusCode} - ${response.body}",
          name: "loadUserChildren",
        );
        throw Exception("error_loading_users");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      developer.log("Loaded users: $decoded", name: "loadUserChildren");
      final List<CafeteriaUser> users = [];

      //TODO: Ask for user filters
      for (var user in decoded["results"]) {
        users.add(CafeteriaUser.fromJson(user));
      }

      return users;
    } catch (e) {
      developer.log("Error loading users: $e", name: "loadUserChildren");
      throw Exception("error_loading_users");
    }
  }

  Future<DebtorsResponse> loadDebtorsChildren() async {
    try {
      final familyId = api.sessionRepository.session?.familyId;
      developer.log("Loading debtors from API", name: "loadUserChildren");

      final response = await api.get("${ApiUrls.familyUrl}$familyId/balance/");

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load debtors: ${response.statusCode} - ${response.body}",
          name: "loadDebtorsChildren",
        );
        throw Exception("error_loading_debtors");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));

      developer.log("Loaded debtors: $decoded", name: "loadDebtorsChildren");

      final double totalDebt = (decoded["all_debt"] as num?)?.toDouble() ?? 0.0;

      final List<UserModel> users = [];

      for (var student in decoded["students"]) {
        users.add(UserModel.fromJson(student));
      }

      return DebtorsResponse(totalDebt: totalDebt, users: users);
    } catch (e) {
      developer.log("Error loading debtors: $e", name: "loadDebtorsChildren");
      throw Exception("error_loading_debtors");
    }
  }
}
