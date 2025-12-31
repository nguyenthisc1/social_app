import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';
import 'network_info.dart';

/// HTTP client for making API requests
class ApiClient {
  final http.Client client;
  final NetworkInfo networkInfo;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.networkInfo,
    required this.baseUrl,
  });

  /// Common headers for all requests
  Map<String, String> _getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// GET request
  Future<dynamic> get({
    required String endpoint,
    String? token,
    Map<String, String>? queryParameters,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(message: 'No internet connection');
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );
      
      final response = await client.get(
        uri,
        headers: _getHeaders(token: token),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Failed to connect to server');
    }
  }

  /// POST request
  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(message: 'No internet connection');
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await client.post(
        uri,
        headers: _getHeaders(token: token),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Failed to connect to server');
    }
  }

  /// PUT request
  Future<dynamic> put({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(message: 'No internet connection');
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await client.put(
        uri,
        headers: _getHeaders(token: token),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Failed to connect to server');
    }
  }

  /// DELETE request
  Future<dynamic> delete({
    required String endpoint,
    String? token,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(message: 'No internet connection');
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await client.delete(
        uri,
        headers: _getHeaders(token: token),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Failed to connect to server');
    }
  }

  /// Handle API response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    }

    final message = _extractErrorMessage(response);

    switch (statusCode) {
      case 401:
        throw UnauthorizedException(message: message);
      case 404:
        throw NotFoundException(message: message);
      case 422:
        throw ValidationException(
          message: message,
          errors: _extractValidationErrors(response),
        );
      default:
        throw ServerException(
          message: message,
          statusCode: statusCode,
        );
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? data['error'] ?? 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }

  /// Extract validation errors from response
  Map<String, dynamic>? _extractValidationErrors(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['errors'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }
}

