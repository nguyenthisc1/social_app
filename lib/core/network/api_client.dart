import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:social_app/core/domain-base/exceptions/generic_exception.dart';
import 'package:social_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:social_app/features/auth/domain/auth_exceptions.dart';

import '../utils/device_service.dart';
import 'network_info.dart';

class ApiClient {
  final http.Client httpClient;
  final NetworkInfo networkInfo;
  final String baseUrl;
  final AuthLocalDataSource tokenProvider;

  ApiClient({
    required this.httpClient,
    required this.networkInfo,
    required this.baseUrl,
    required this.tokenProvider,
  });

  /// Common headers for all requests (now async for device-id)
  Future<Map<String, String>> _getHeaders({
    Map<String, String>? headers,
    bool hasBody = false,
  }) async {
    final device = await DeviceService.getDeviceId();
    final output = <String, String>{
      'Accept': 'application/json',
      'device-id': device!,
      if (hasBody) 'Content-Type': 'application/json',
    };

    final tokens = await tokenProvider.getCachedTokens();

    if (tokens != null && tokens.accessToken.isNotEmpty) {
      output['Authorization'] = '${tokens.tokenType} ${tokens.accessToken}';
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
      throw NetworkException(userMessage: 'No internet connection');
    }

    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
    final requestHeaders = await _getHeaders(
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
      throw NetworkException(userMessage: 'No internet connection');
    } on http.ClientException {
      throw http.ClientException('Failed to connect to server');
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
      throw NetworkException(userMessage: 'No internet connection');
    }

    // Add headers, including device-id
    final device = await DeviceService.getDeviceId();
    request.headers['device-id'] = device!;

    final tokens = await tokenProvider.getCachedTokens();

    if (tokens != null && tokens.accessToken.isNotEmpty) {
      request.headers['Authorization'] =
          '${tokens.tokenType} ${tokens.accessToken}';
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    try {
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(userMessage: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(userMessage: 'Failed to connect to server');
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
        throw AuthUnauthorizedException(userMessage: message);
      case 404:
        throw NotFoundException(userMessage: message);
      // case 422:
      //   throw ValidationException(
      //     message: message,
      //     errors: _extractValidationErrors(response),
      //   );
      default:
        throw NetworkException(userMessage: message, cause: statusCode);
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
