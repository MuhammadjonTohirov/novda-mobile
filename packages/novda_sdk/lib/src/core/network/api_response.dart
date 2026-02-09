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
      success: json['success'] as bool,
      code: json['code'] as int,
      message: json['message'] as String?,
      error: json['error'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }

  @override
  List<Object?> get props => [success, code, message, error, data];
}
