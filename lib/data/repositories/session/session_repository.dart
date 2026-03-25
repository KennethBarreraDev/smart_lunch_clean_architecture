import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_lunch/core/constants/cache_keys.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/data/providers/secure_storage_provider.dart';

class SessionRepository {
  final StorageProvider storage;

  SessionData? _session;

  SessionRepository(this.storage);

  SessionData? get session => _session;

  void setUserOpenpayId(String openpayId){
    _session = _session?.copyWith(openpayId: openpayId);
  }

  Future<bool> checkAndLoadSession() async {
    String accessToken = await storage.readValue(CacheKeys.accessToken);
    String refreshToken = await storage.readValue(CacheKeys.refreshToken);
    String userId = await storage.readValue(CacheKeys.userId);
    String familyId = await storage.readValue(CacheKeys.familyId);
    String storedRole = await storage.readValue(CacheKeys.userType);
    String cafeteriaId = await storage.readValue(CacheKeys.cafeteriaId);

    developer.log("Acess token: $accessToken", name: "checkAndLoadSession");
    developer.log("Refresh token: $refreshToken", name: "checkAndLoadSession");
    developer.log("Tutor id: $userId", name: "checkAndLoadSession");
    developer.log("Family id: $familyId", name: "checkAndLoadSession");
    developer.log("Stored role: $storedRole", name: "checkAndLoadSession");
    developer.log("Cafeteria id: $cafeteriaId", name: "checkAndLoadSession");

    _fillUserSession(
      accessToken,
      refreshToken,
      cafeteriaId,
      userId,
      storedRole,
      familyId,
    );

    if (accessToken.isNotEmpty && !JwtDecoder.isExpired(accessToken)) {
      return true;
    }

    if (refreshToken.isEmpty) {
      return false;
    }

    String refreshResponse = await refreshAccessToken();

    return refreshResponse.isNotEmpty;
  }

  Future<String> refreshAccessToken() async {
    try {
      await storage.deleteAll();
      developer.log("Refreshing access token", name: "checkAndLoadSession");
      final refreshUrl = ApiUrls.refreshTokenUrl;

      developer.log("Refresh url: $refreshUrl", name: "checkAndLoadSession");

      final response = await http.post(
        headers: {
          "cafeteria": _session?.cafeteriaId ?? "",
          "Content-Type": "application/json",
        },
        Uri.parse(refreshUrl),
        body: json.encode({"refresh": _session?.refreshToken}),
      );

      if (response.statusCode != 200) {
        developer.log(
          "Error refreshing access token: ${response.statusCode} ${response.body}",
          name: "checkAndLoadSession",
        );

        return "";
      }

      Map<String, dynamic> responseMap = json.decode(response.body);

      developer.log("Response map: $responseMap", name: "checkAndLoadSession");

      await getMainInfoFromToken(responseMap, logName: "checkAndLoadSession");

      return responseMap["access"];
    } catch (e) {
      developer.log(
        "Error refreshing access token: $e",
        name: "checkAndLoadSession",
      );
      return "";
    }
  }

  Future<bool> loginUserWithCredentials(
    String username,
    String password,
  ) async {
    try {
      developer.log(
        "Attempting login with username: $username",
        name: "loginUserWithCredentials",
      );

      if (username.isEmpty || password.isEmpty) {
        developer.log("Empty credentials", name: "loginUserWithCredentials");
        throw Exception("empty_credentials");
      }

      String loginUrl = ApiUrls.loginUrl;

      developer.log("Login url: $loginUrl", name: "loginUserWithCredentials");

      final response = await http.post(
        Uri.parse(ApiUrls.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"username": username, "password": password}),
      );

      if (response.statusCode != 200) {
        developer.log(
          "Invalid credentials for username: $username",
          name: "loginUserWithCredentials",
        );
        throw Exception("invalid_credentials");
      }

      Map<String, dynamic> responseMap = json.decode(response.body);

      await getMainInfoFromToken(
        responseMap,
        logName: "loginUserWithCredentials",
      );

      return true;
    } catch (e) {
      developer.log("Error logging in: $e", name: "loginUserWithCredentials");
      throw Exception("error_logging_in");
    }
  }

  Future<void> getMainInfoFromToken(
    Map<String, dynamic> responseMap, {
    String logName = "LOG",
  }) async {
    String accessToken = responseMap["access"] ?? "";
    String refreshToken = responseMap["refresh"] ?? "";

    Map<String, dynamic> decodedAccessToken = JwtDecoder.decode(accessToken);

    developer.log(
      "Decoded access token: $decodedAccessToken",
      name: logName,
    );
    //TODO: Ask for groups in backend
    bool isTutor = true || decodedAccessToken["groups"].contains("Tutor");
    bool isStudent = decodedAccessToken["groups"].contains("Student");
    bool isTeacher = decodedAccessToken["groups"].contains("Teacher");

    developer.log("Is tutor: $isTutor", name: logName);
    developer.log("Is student: $isStudent", name: logName);
    developer.log("Is teacher: $isTeacher", name: logName);

    UserRole userType = UserRole.none;

    if (isTeacher) {
      await saveUserInfoToCache(
        accessToken,
        refreshToken,
        "Teacher",
        decodedAccessToken["user_id"].toString(),
        decodedAccessToken["family_id"].toString(),
        logName: logName,
      );
    } else if (isTutor) {
      await saveUserInfoToCache(
        accessToken,
        refreshToken,
        "Tutor",
        decodedAccessToken["user_id"].toString(),
        decodedAccessToken["family_id"].toString(),
        logName: logName,
      );
    } else if (isStudent) {
      userType = UserRole.student;
      await saveUserInfoToCache(
        accessToken,
        refreshToken,
        "Student",
        decodedAccessToken["user_id"].toString(),
        decodedAccessToken["family_id"].toString(),
        logName: logName,
      );
    }
  }

  Future<void> saveUserInfoToCache(
    String accessToken,
    String refreshToken,
    String userType,
    String userId,
    String familyId, {
    String logName = "LOG",
  }) async {
    developer.log("Saving user info", name: logName);
    developer.log("User type: $userType", name: logName);
    developer.log("User id: $userId", name: logName);
    developer.log("Family id: $familyId", name: logName);
    developer.log("Access token: $accessToken", name: logName);
    developer.log("Refresh token: $refreshToken", name: logName);

    await storage.writeValue(CacheKeys.accessToken, accessToken);
    await storage.writeValue(CacheKeys.refreshToken, refreshToken);
    await storage.writeValue(CacheKeys.userType, userType);
    await storage.writeValue(CacheKeys.familyId, familyId);
    await storage.writeValue(CacheKeys.userId, userId);

    _fillUserSession(
      accessToken,
      refreshToken,
      familyId,
      userId,
      userType,
      familyId,
    );
  }

  void _fillUserSession(
    String accessToken,
    String refreshToken,
    String cafeteriaId,
    String userId,
    String storedRole,
    String familyId,
  ) {
    UserRole userType = UserRole.none;
    switch (storedRole) {
      case "Tutor":
        userType = UserRole.tutor;
        break;
      case "Student":
        userType = UserRole.student;
        break;
      case "Teacher":
        userType = UserRole.teacher;
        break;
    }

    _session = SessionData(
      accessToken: accessToken,
      refreshToken: refreshToken,
      cafeteriaId: cafeteriaId,
      userId: userId,
      userType: userType,
      familyId: familyId,
      openpayId: null,
    );
  }
}
