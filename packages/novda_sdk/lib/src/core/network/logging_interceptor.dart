import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Logging-only interceptor. Logs requests, responses, and errors.
class LoggingInterceptor extends InterceptorsWrapper {
  static const _logName = 'NovdaSDK';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      'REQUEST[${options.method}] => PATH: ${options.path}',
      name: _logName,
    );
    if (options.queryParameters.isNotEmpty) {
      developer.log(
        'Query Params: ${options.queryParameters}',
        name: _logName,
      );
    }
    if (options.data != null) {
      developer.log('Request Data: ${options.data}', name: _logName);
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      name: _logName,
    );
    developer.log('Response Data: ${response.data}', name: _logName);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      name: _logName,
      error: err.error,
    );
    if (err.response != null) {
      developer.log(
        'Error Response Data: ${err.response?.data}',
        name: _logName,
      );
    }
    handler.next(err);
  }
}
