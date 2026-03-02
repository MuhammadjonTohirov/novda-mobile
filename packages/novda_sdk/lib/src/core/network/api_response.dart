import 'package:equatable/equatable.dart';

/// Standard API response wrapper matching backend format
class ApiResponse<T> extends Equatable {
  const ApiResponse({
    required this.success,
    required this.code,
    this.message,
    this.error,
    this.data,
  });

  final bool success;
  final int code;
  final String? message;
  final String? error;
  final T? data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse(
      success: _parseSuccess(json['success']),
      code: _parseCode(json['code']),
      message: json['message'] as String?,
      error: json['error'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }

  static bool _parseSuccess(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return false;
  }

  static int _parseCode(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [success, code, message, error, data];
}
