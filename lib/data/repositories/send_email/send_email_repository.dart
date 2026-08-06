import 'dart:convert';
import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class SendEmailRepository {
  final ApiClientRepository api;

  SendEmailRepository(this.api);

  Future<bool> sendVerificationEmail(String email) async {
    final response = await api.post(
      ApiUrls.sendEmail,
      {"email": email},
      logName: "sendVerificationEmail",
    );

    if (response.statusCode == 200) {
      return true;
    }

    developer.log(
      "Failed to send verification email: ${response.statusCode} - ${response.body}",
      name: "sendVerificationEmail",
    );

    String? code;
    try {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      code = decoded["code"] as String?;
    } catch (_) {
      code = null;
    }

    if (response.statusCode == 400 || code == "validation_error") {
      throw Exception("validation_error");
    }

    if (response.statusCode == 500 || code == "internal_server_error") {
      throw Exception("internal_server_error");
    }

    throw Exception("error_sending_email");
  }
}
