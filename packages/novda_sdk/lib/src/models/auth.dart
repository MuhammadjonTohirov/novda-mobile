import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'user.dart';

/// Response from OTP request
class OtpRequestResponse extends Equatable {
  const OtpRequestResponse({required this.expiresIn});

  final int expiresIn;

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponse(
      expiresIn: json['expires_in'] as int,
    );
  }

  @override
  List<Object?> get props => [expiresIn];
}

/// Response from OTP verification
class AuthTokens extends Equatable {
  const AuthTokens({
    required this.access,
    required this.refresh,
    this.user,
  });

  final String access;
  final String refresh;
  final User? user;

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [access, refresh, user];
}

/// Request for OTP
class OtpRequest {
  const OtpRequest({
    required this.phone,
    this.purpose = OtpPurpose.auth,
  });

  final String phone;
  final OtpPurpose purpose;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'purpose': purpose.value,
      };
}

/// Request for OTP verification
class OtpVerifyRequest {
  const OtpVerifyRequest({
    required this.phone,
    required this.code,
  });

  final String phone;
  final String code;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
      };
}

/// Request for token refresh
class TokenRefreshRequest {
  const TokenRefreshRequest({required this.refresh});

  final String refresh;

  Map<String, dynamic> toJson() => {'refresh': refresh};
}
