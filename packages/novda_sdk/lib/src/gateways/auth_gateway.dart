import '../core/network/api_client.dart';
import '../models/auth.dart';

/// Gateway interface for authentication operations
abstract interface class AuthGateway {
  Future<OtpRequestResponse> requestOtp(OtpRequest request);
  Future<AuthTokens> verifyOtp(OtpVerifyRequest request);
  Future<AuthTokens> refreshToken(TokenRefreshRequest request);
  Future<void> logout(TokenRefreshRequest request);
}

/// Implementation of AuthGateway
class AuthGatewayImpl implements AuthGateway {
  AuthGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<OtpRequestResponse> requestOtp(OtpRequest request) async {
    return _client.post(
      '/api/v1/auth/otp/request',
      data: request.toJson(),
      fromJson: (json) =>
          OtpRequestResponse.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  @override
  Future<AuthTokens> verifyOtp(OtpVerifyRequest request) async {
    return _client.post(
      '/api/v1/auth/otp/verify',
      data: request.toJson(),
      fromJson: (json) => AuthTokens.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  @override
  Future<AuthTokens> refreshToken(TokenRefreshRequest request) async {
    return _client.post(
      '/api/v1/auth/token/refresh',
      data: request.toJson(),
      fromJson: (json) => AuthTokens.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  @override
  Future<void> logout(TokenRefreshRequest request) async {
    await _client.post(
      '/api/v1/auth/logout',
      data: request.toJson(),
    );
  }
}
