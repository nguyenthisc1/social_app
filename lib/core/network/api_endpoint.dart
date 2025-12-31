import 'package:social_app/core/network/api_client.dart';

class ApiEndpoint {
  final ApiClient apiClient;

  ApiEndpoint({required this.apiClient});

  Future<Map<String, dynamic>> get({
    required String endpoint,
    String? token,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final result = await apiClient.request(
      method: 'GET',
      endpoint: endpoint,
      token: token,
      query: queryParameters,
      headers: headers,
    );
    if (result == null) {
      throw Exception('GET request failed: no data returned');
    }
    return result;
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? headers,
  }) async {
    final result = await apiClient.request(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      token: token,
      headers: headers,
    );
    if (result == null) {
      throw Exception('POST request failed: no data returned');
    }
    return result;
  }

  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? headers,
  }) async {
    final result = await apiClient.request(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      token: token,
      headers: headers,
    );
    if (result == null) {
      throw Exception('PUT request failed: no data returned');
    }
    return result;
  }

  Future<Map<String, dynamic>> delete({
    required String endpoint,
    String? token,
    Map<String, String>? headers,
  }) async {
    final result = await apiClient.request(
      method: 'DELETE',
      endpoint: endpoint,
      token: token,
      headers: headers,
    );
    if (result == null) {
      throw Exception('DELETE request failed: no data returned');
    }
    return result;
  }
}
