import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'api_response.dart';

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

/// Dio-based implementation of ApiClient
class DioApiClient implements ApiClient {
  static const _refreshEndpointPath = '/api/v1/auth/token/refresh';
  static const _skipAuthRefreshExtraKey = 'skip_auth_refresh';
  static const _authRetryAttemptedExtraKey = 'auth_retry_attempted';

  DioApiClient({
    required ApiClientConfig config,
    required TokenProvider tokenProvider,
    Dio? dio,
  }) : _config = config,
       _tokenProvider = tokenProvider,
       _dio = dio ?? Dio() {
    _setupDio();
  }

  final ApiClientConfig _config;
  final TokenProvider _tokenProvider;
  final Dio _dio;
  String _locale = 'en';

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

    // Logging Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log(
            'REQUEST[${options.method}] => PATH: ${options.path}',
            name: 'NovdaSDK',
          );
          if (options.queryParameters.isNotEmpty) {
            developer.log(
              'Query Params: ${options.queryParameters}',
              name: 'NovdaSDK',
            );
          }
          if (options.data != null) {
            developer.log('Request Data: ${options.data}', name: 'NovdaSDK');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            name: 'NovdaSDK',
          );
          developer.log('Response Data: ${response.data}', name: 'NovdaSDK');
          handler.next(response);
        },
        onError: (DioException error, handler) {
          developer.log(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            name: 'NovdaSDK',
            error: error.error,
          );
          if (error.response != null) {
            developer.log(
              'Error Response Data: ${error.response?.data}',
              name: 'NovdaSDK',
            );
          }
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-API-Key'] = _config.apiKey;
          options.headers['Accept-Language'] = _locale;

          final token = _tokenProvider.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          if (_shouldTryRefresh(error)) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              error.requestOptions.extra[_authRetryAttemptedExtraKey] = true;
              final response = await _retry(error.requestOptions);
              return handler.resolve(response);
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = _tokenProvider.refreshToken;
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        _refreshEndpointPath,
        data: {'refresh': refreshToken},
        options: Options(
          headers: {'Authorization': null},
          extra: {_skipAuthRefreshExtraKey: true},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          await _tokenProvider.saveTokens(
            access: data['access'] as String,
            refresh: data['refresh'] as String,
          );
          return true;
        }
      }
    } catch (_) {
      await _tokenProvider.clearTokens();
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
    final token = _tokenProvider.accessToken;
    if (token != null) {
      requestOptions.headers['Authorization'] = 'Bearer $token';
    }
    return _dio.fetch(requestOptions);
  }

  bool _shouldTryRefresh(DioException error) {
    if (error.response?.statusCode != 401) return false;

    final options = error.requestOptions;
    final isRefreshRequest = options.path.contains(_refreshEndpointPath);
    final skipRefresh = options.extra[_skipAuthRefreshExtraKey] == true;
    final alreadyRetried = options.extra[_authRetryAttemptedExtraKey] == true;

    return !isRefreshRequest && !skipRefresh && !alreadyRetried;
  }

  @override
  void setLocale(String locale) {
    _locale = locale;
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

  T _handleResponse<T>(Response response, T Function(Object? json)? fromJson) {
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
