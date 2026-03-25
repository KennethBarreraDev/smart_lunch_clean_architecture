import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:smart_lunch/data/repositories/session/session_repository.dart';

class ApiClientRepository {

  final SessionRepository sessionRepository;

  ApiClientRepository(this.sessionRepository);

  Map<String, String> _baseHeaders({bool json = false}) {

    final session = sessionRepository.session;

    final headers = <String, String>{
      "Authorization": "Bearer ${session?.accessToken ?? ""}",
      "cafeteria": session?.cafeteriaId ?? "",
    };

    if (json) {
      headers["Content-Type"] = "application/json";
    }

    return headers;
  }

  Future<http.Response> get(String url, {String logName = "LOG"}) {
    developer.log("GET $url", name: logName);
    return http.get(
      Uri.parse(url),
      headers: _baseHeaders(),
    );
  }

  Future<http.Response> post(String url, Map<String, dynamic> body, {String logName = "LOG"}) {
    developer.log("POST $url", name: logName);
    return http.post(
      Uri.parse(url),
      headers: _baseHeaders(json: true),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String url, Map<String, dynamic> body, {String logName = "LOG"}) {
    developer.log("PUT $url", name: logName);
    return http.put(
      Uri.parse(url),
      headers: _baseHeaders(json: true),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String url, {String logName = "LOG"}) {
    developer.log("DELETE $url", name: logName);
    return http.delete(
      Uri.parse(url),
      headers: _baseHeaders(),
    );
  }
}