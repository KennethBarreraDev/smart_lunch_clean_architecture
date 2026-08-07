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

      final response = await api.get(
        "${ApiUrls.cafeteriaUserUrl}?page_size=100",
      );

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
        (user) =>
            user.user?.id.toString() == api.sessionRepository.session?.userId,
      );
    } catch (e) {
      developer.log("Error loading user: $e", name: "loadCurrentUser");
      throw Exception("error_loading_user");
    }
  }

  // TODO: Could be eliminated this function, No used
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

  Future<List<CafeteriaUser>> loadFamilyChildren() async {
    try {
      final familyId = api.sessionRepository.session?.familyId;
      if (familyId == null) {
        developer.log('FamilyId null', name: "loadFamilyChildren");
        return [];
      }

      developer.log(
        "Loading family children from API",
        name: "loadFamilyChildren",
      );

      final uri = Uri.parse(
        ApiUrls.cafeteriaUserUrl,
      ).replace(queryParameters: {'family': familyId.toString()});

      final response = await api.get(
        uri.toString(),
        logName: "loadFamilyChildren",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load family children: ${response.statusCode}:  ${response.body}",
          name: "loadFamilyChildren",
        );
        throw Exception("Error loading family children");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      developer.log(
        "Loaded family children: $decoded",
        name: "loadFamilyChildren",
      );

      final List<CafeteriaUser> allUsers = [];

      for (var user in decoded["results"]) {
        allUsers.add(CafeteriaUser.fromJson(user));
      }

      final List<CafeteriaUser> studentsOnly = allUsers.where((user) {
        return user.user?.userType == "ST";
      }).toList();

      developer.log(
        "Found ${allUsers.length} total family members, ${studentsOnly.length} are students",
        name: "loadFamilyChildren",
      );

      return studentsOnly;
    } catch (e) {
      developer.log(
        "Error get family children: ${e.toString()}",
        name: "loadFamilyChildren",
      );
      throw Exception('Error get family children');
    }
  }

  Future<CafeteriaUser> loadUserById(int cafeteriaUserId) async {
    try {
      final response = await api.get(
        "${ApiUrls.cafeteriaUserUrl}$cafeteriaUserId/",
      );

      if (response.statusCode != 200) {
        throw Exception("Error loading user");
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));

      return CafeteriaUser.fromJson(decoded);
    } catch (e) {
      developer.log("Error loading user by id: $e", name: "loadUserById");
      throw Exception("error_loading_user");
    }
  }

  Future<void> updateMainUserProfile({
    required int cafeteriaUserId,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final response = await api.put(
        "${ApiUrls.cafeteriaUserUrl}$cafeteriaUserId/",
        {
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
        },
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to update user profile: ${response.statusCode} - ${response.body}",
          name: "updateMainUserProfile",
        );
        throw Exception("error_updating_user_profile");
      }
    } catch (e) {
      developer.log("Error updating user profile: $e", name: "updateMainUserProfile");
      throw Exception("error_updating_user_profile");
    }
  }

  Future<void> updateUserInfo({
    required int cafeteriaUserId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final safeBody = Map<String, dynamic>.from(body);

      if (safeBody.containsKey('daily_limit') &&
          safeBody['daily_limit'] != null) {
        final num limit = safeBody['daily_limit'];
        safeBody['daily_limit'] = limit < 0 ? 0.0 : limit;
      }

      final response = await api.patch(
        "${ApiUrls.cafeteriaUserUrl}$cafeteriaUserId/",
        safeBody,
      );

      if (response.statusCode != 200) {
        throw Exception("Error updating an cafeteriaUser");
      }
    } catch (e) {
      developer.log("Error: $e");
      throw Exception("Error_update_cafeteriaUser");
    }
  }
}
