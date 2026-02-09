import 'package:equatable/equatable.dart';

/// Base exception for all API errors
sealed class ApiException extends Equatable implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Network connection error
final class NetworkException extends ApiException {
  const NetworkException({super.message = 'Network connection failed'});
}

/// Server returned an error response
final class ServerException extends ApiException {
  const ServerException({
    required super.message,
    required super.statusCode,
    this.error,
  });

  final String? error;

  @override
  List<Object?> get props => [message, statusCode, error];
}

/// Request validation error (400)
final class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    this.errors,
  }) : super(statusCode: 400);

  final Map<String, List<String>>? errors;

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Authentication error (401)
final class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Unauthorized'})
      : super(statusCode: 401);
}

/// Resource not found (404)
final class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Resource not found'})
      : super(statusCode: 404);
}

/// Rate limit exceeded (429)
final class RateLimitException extends ApiException {
  const RateLimitException({
    super.message = 'Rate limit exceeded',
    this.retryAfterSeconds,
  }) : super(statusCode: 429);

  final int? retryAfterSeconds;

  @override
  List<Object?> get props => [message, statusCode, retryAfterSeconds];
}

/// Unknown/unexpected error
final class UnknownException extends ApiException {
  const UnknownException({super.message = 'An unexpected error occurred'});
}
