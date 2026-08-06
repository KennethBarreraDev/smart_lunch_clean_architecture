import 'dart:developer' as developer;

import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class SendEmailRepository {
  final ApiClientRepository api;

  SendEmailRepository(this.api);

  Future<bool> sendVerificationEmail(String email) async {
    try {
      final response = await api.post(
        ApiUrls.sendEmail,
        {"email": email},
        logName: "sendVerificationEmail",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to send verification email: ${response.statusCode} - ${response.body}",
          name: "sendVerificationEmail",
        );
        throw Exception("error_sending_email");
      }

      return true;
    } catch (e) {
      developer.log(
        "Error sending verification email: $e",
        name: "sendVerificationEmail",
        error: e,
      );
      throw Exception("error_sending_email");
    }
  }
}
