import '../gateways/auth_gateway.dart';
import '../models/auth.dart';

/// Use case interface for authentication operations
abstract interface class AuthUseCase {
  /// Request OTP code for phone authentication
  Future<OtpRequestResponse> requestOtp({
    required String phone,
    String purpose,
  });

  /// Verify OTP code and get authentication tokens
  Future<AuthTokens> verifyOtp({
    required String phone,
    required String code,
  });

  /// Refresh access token using refresh token
  Future<AuthTokens> refreshToken({required String refreshToken});

  /// Logout user by invalidating refresh token
  Future<void> logout({required String refreshToken});
}

/// Implementation of AuthUseCase
class AuthUseCaseImpl implements AuthUseCase {
  AuthUseCaseImpl(this._gateway);

  final AuthGateway _gateway;

  @override
  Future<OtpRequestResponse> requestOtp({
    required String phone,
    String purpose = 'auth',
  }) {
    return _gateway.requestOtp(OtpRequest(phone: phone, purpose: purpose));
  }

  @override
  Future<AuthTokens> verifyOtp({
    required String phone,
    required String code,
  }) {
    return _gateway.verifyOtp(OtpVerifyRequest(phone: phone, code: code));
  }

  @override
  Future<AuthTokens> refreshToken({required String refreshToken}) {
    return _gateway.refreshToken(TokenRefreshRequest(refresh: refreshToken));
  }

  @override
  Future<void> logout({required String refreshToken}) {
    return _gateway.logout(TokenRefreshRequest(refresh: refreshToken));
  }
}
