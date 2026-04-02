import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';

class ApiClient {
  static const String baseUrl = ApiConstants.baseUrl;

  static Map<String, String> _headers({String? token}) {
    final headers = {
      "Content-Type": "application/json",
    };

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  static Future<http.Response> get(
      String endpoint, {
        String? token,
      }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.get(
      url,
      headers: _headers(token: token),
    );
  }

  static Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.post(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.put(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body),
    );
  }
}