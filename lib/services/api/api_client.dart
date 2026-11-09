import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiClient {
  static const String _tokenKey = 'auth_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> _getHeaders({
    bool requiresAuth = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET
  static Future<dynamic> get(String url, {bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException catch (_) {
      throw ApiException(
        'Cannot connect to backend server at ${ApiConfig.baseUrl}.\n'
        'Please verify:\n'
        '1. Laptop & phone are on the same Wi-Fi.\n'
        '2. Backend is running (npm run dev).\n'
        '3. IP address in Settings matches your laptop IPv4.',
      );
    } on TimeoutException catch (_) {
      throw ApiException(
        'Connection timed out while contacting server at ${ApiConfig.baseUrl}.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // POST
  static Future<dynamic> post(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException catch (_) {
      throw ApiException(
        'Cannot connect to backend server at ${ApiConfig.baseUrl}.\n'
        'Ensure the local Express backend is running and both devices share the same Wi-Fi.',
      );
    } on TimeoutException catch (_) {
      throw ApiException(
        'Request timed out while waiting for backend response.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request error: ${e.toString()}');
    }
  }

  // PUT
  static Future<dynamic> put(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException catch (_) {
      throw ApiException('Unable to reach backend server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request error: ${e.toString()}');
    }
  }

  // PATCH
  static Future<dynamic> patch(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http
          .patch(
            Uri.parse(url),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException catch (_) {
      throw ApiException('Unable to reach backend server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request error: ${e.toString()}');
    }
  }

  // DELETE
  static Future<dynamic> delete(String url, {bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException catch (_) {
      throw ApiException('Unable to reach backend server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request error: ${e.toString()}');
    }
  }

  static dynamic _processResponse(http.Response response) {
    dynamic jsonBody;
    try {
      jsonBody = jsonDecode(response.body);
    } catch (_) {
      jsonBody = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    } else {
      final errorMsg = (jsonBody is Map && jsonBody['message'] != null)
          ? jsonBody['message']
          : 'Server responded with error status ${response.statusCode}';
      throw ApiException(errorMsg, response.statusCode);
    }
  }
}
