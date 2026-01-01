import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../errors/exceptions.dart';
import 'network_info.dart';

class ApiClient {
  final http.Client httpClient;
  final NetworkInfo networkInfo;
  final String baseUrl;

  ApiClient({
    required this.httpClient,
    required this.networkInfo,
    required this.baseUrl,
  });

  /// Common headers for all requests
  Map<String, String> _getHeaders({
    String? token,
    Map<String, String>? headers,
    bool hasBody = false,
  }) {
    final output = <String, String>{
      'Accept': 'application/json',
      if (hasBody) 'Content-Type': 'application/json',
    };
    if (token != null) {
      output['Authorization'] = 'Bearer $token';
    }
    if (headers != null) {
      output.addAll(headers);
    }
    return output;
  }

  /// Generic HTTP request
  Future<Map<String, dynamic>> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    String? token,
    Map<String, String>? headers,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(message: 'No internet connection');
    }

    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
    final requestHeaders = _getHeaders(
      token: token,
      headers: headers,
      hasBody: body != null,
    );
    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await httpClient.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await httpClient.post(
            uri,
            headers: requestHeaders,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await httpClient.put(
            uri,
            headers: requestHeaders,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await httpClient.delete(uri, headers: requestHeaders);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Failed to connect to server');
    }
  }

  /// Upload (multipart/form) request
  Future<Map<String, dynamic>?> upload({
    required String endpoint,
    required http.MultipartRequest request,
    String? token,
    Map<String, String>? headers,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(message: 'No internet connection');
    }

    // Add headers if provided
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    try {
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
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return data;
      }
      // fallback if not a map
      return {'data': data};
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
        throw ServerException(message: message, statusCode: statusCode);
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'An error occurred';
      }
      return 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }

  /// Extract validation errors from response
  Map<String, dynamic>? _extractValidationErrors(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> &&
          data['errors'] is Map<String, dynamic>) {
        return data['errors'] as Map<String, dynamic>?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
