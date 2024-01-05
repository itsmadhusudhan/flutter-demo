import 'package:chatterbox/core/logger.dart';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d(
      "REQUEST || ${options.method} => PATH: ${options.uri}",
      time: DateTime.now(),
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
        "RESPONSE || ${response.requestOptions.method} || ${response.statusCode} => PATH: ${response.requestOptions.uri}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}");
    return super.onError(err, handler);
  }
}
