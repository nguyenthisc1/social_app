import 'package:social_app/core/core.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';

import '../../../../../user/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BaseResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );

    return BaseResponse.fromJson(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.register,
      body: {'email': email, 'username': username, 'password': password},
    );

    return BaseResponse.fromJson(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<BaseResponse<void>> logout(userId) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.logout,
      body: {'userId': userId},
    );

    return BaseResponse.fromJson(response, (_) {});
  }

  @override
  Future<BaseResponse<UserModel>> getCurrentUser({
    required String accessToken,
  }) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.profile,
      token: accessToken,
    );

    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<UserModel>> updateProfile({
    required String accessToken,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['display_name'] = displayName;
    if (bio != null) body['bio'] = bio;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;

    final response = await apiClient.request(
      method: 'PUT',
      endpoint: ApiEndpoints.updateProfile,
      token: accessToken,
      body: body,
    );

    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await apiClient.request(
      method: 'PUT',
      endpoint: '${ApiEndpoints.profile}/change-password',
      token: accessToken,
      body: {'current_password': currentPassword, 'new_password': newPassword},
    );

    return BaseResponse.fromJson(response, (data) {});
  }

  @override
  Future<BaseResponse<void>> requestPasswordReset({
    required String email,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.forgotPassword,
      body: {'email': email},
    );

    return BaseResponse.fromJson(response, (data) {});
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.resetPassword,
      body: {'token': token, 'new_password': newPassword},
    );

    return BaseResponse.fromJson(response, (data) {});
  }

  @override
  Future<BaseResponse<void>> verifyEmail({required String token}) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: '${ApiEndpoints.profile}/verify-email',
      body: {'token': token},
    );

    return BaseResponse.fromJson(response, (data) {});
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.refreshToken,
      body: {'refreshToken': refreshToken},
    );

    return BaseResponse.fromJson(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }
}
