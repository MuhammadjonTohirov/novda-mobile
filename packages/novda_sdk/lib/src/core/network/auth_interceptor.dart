import 'package:dio/dio.dart';

import 'api_client.dart';

/// Handles API-key injection, bearer-token injection, and 401 token refresh.
class AuthInterceptor extends InterceptorsWrapper {
  AuthInterceptor({
    required String apiKey,
    required TokenProvider tokenProvider,
    required Dio dio,
  })  : _apiKey = apiKey,
       _tokenProvider = tokenProvider,
       _dio = dio;

  static const _refreshEndpointPath = '/api/v1/auth/token/refresh';
  static const _skipAuthRefreshExtraKey = 'skip_auth_refresh';
  static const _authRetryAttemptedExtraKey = 'auth_retry_attempted';

  final String _apiKey;
  final TokenProvider _tokenProvider;
  final Dio _dio;
  String _locale = 'en';

  void setLocale(String locale) => _locale = locale;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-API-Key'] = _apiKey;
    options.headers['Accept-Language'] = _locale;

    final token = _tokenProvider.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldTryRefresh(err)) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        err.requestOptions.extra[_authRetryAttemptedExtraKey] = true;
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      }
    }
    handler.next(err);
  }

  bool _shouldTryRefresh(DioException error) {
    if (error.response?.statusCode != 401) return false;

    final options = error.requestOptions;
    final isRefreshRequest = options.path.contains(_refreshEndpointPath);
    final skipRefresh = options.extra[_skipAuthRefreshExtraKey] == true;
    final alreadyRetried = options.extra[_authRetryAttemptedExtraKey] == true;

    return !isRefreshRequest && !skipRefresh && !alreadyRetried;
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
}
