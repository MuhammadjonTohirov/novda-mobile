import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'api_response.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Token provider interface for authentication
abstract interface class TokenProvider {
  String? get accessToken;
  String? get refreshToken;
  Future<void> saveTokens({required String access, required String refresh});
  Future<void> clearTokens();
}

/// Configuration for the API client
class ApiClientConfig {
  const ApiClientConfig({
    required this.baseUrl,
    required this.apiKey,
    this.defaultLocale = 'en',
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  final String baseUrl;
  final String apiKey;
  final String defaultLocale;
  final Duration connectTimeout;
  final Duration receiveTimeout;
}

/// HTTP client for API communication
abstract interface class ApiClient {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  });

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  });

  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  });

  Future<void> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  void setLocale(String locale);
}

/// Dio-based implementation of [ApiClient].
///
/// Interceptors are extracted into [LoggingInterceptor] and [AuthInterceptor].
class DioApiClient implements ApiClient {
  DioApiClient({
    required ApiClientConfig config,
    required TokenProvider tokenProvider,
    Dio? dio,
  })  : _config = config,
       _dio = dio ?? Dio() {
    _authInterceptor = AuthInterceptor(
      apiKey: config.apiKey,
      tokenProvider: tokenProvider,
      dio: _dio,
    );
    _setupDio();
  }

  final ApiClientConfig _config;
  final Dio _dio;
  late final AuthInterceptor _authInterceptor;

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: _config.connectTimeout,
      receiveTimeout: _config.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      LoggingInterceptor(),
      _authInterceptor,
    ]);
  }

  @override
  void setLocale(String locale) {
    _authInterceptor.setLocale(locale);
  }

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  T _handleResponse<T>(
    Response response,
    T Function(Object? json)? fromJson,
  ) {
    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('success')) {
      final apiResponse = ApiResponse.fromJson(data, fromJson);
      if (!apiResponse.success) {
        throw ServerException(
          message: apiResponse.error ?? 'Request failed',
          statusCode: apiResponse.code,
          error: apiResponse.error,
        );
      }
      if (fromJson != null && apiResponse.data != null) {
        return apiResponse.data as T;
      }
    }

    if (fromJson != null) {
      return fromJson(data);
    }

    return data as T;
  }

  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String? message;
        String? errorText;

        if (data is Map<String, dynamic>) {
          message = data['message'] as String?;
          errorText = data['error'] as String?;
        }

        return switch (statusCode) {
          400 => ValidationException(
            message: errorText ?? message ?? 'Validation failed',
          ),
          401 => UnauthorizedException(
            message: errorText ?? message ?? 'Unauthorized',
          ),
          404 => NotFoundException(
            message: errorText ?? message ?? 'Resource not found',
          ),
          429 => RateLimitException(
            message: errorText ?? message ?? 'Rate limit exceeded',
          ),
          _ => ServerException(
            message: errorText ?? message ?? 'Server error',
            statusCode: statusCode ?? 500,
            error: errorText,
          ),
        };

      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request cancelled');

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }
}
