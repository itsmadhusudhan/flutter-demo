import 'dart:convert';

import 'package:chatterbox/core/logger.dart';
import 'package:chatterbox/core/network/inteceptors/logging_interceptor.dart';
import 'package:chatterbox/features/auth/data/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

// https://github.com/cfug/dio/blob/main/example/lib/queued_interceptor_crsftoken.dart

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

final storage = FlutterSecureStorage(
  aOptions: _getAndroidOptions(),
  iOptions: const IOSOptions(),
);

Map<String, dynamic> _parseAndDecode(String response) {
  return jsonDecode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> parseJson(String text) {
  return compute(_parseAndDecode, text);
}

@LazySingleton()
class ApiClient {
  late final Dio dio;
  final ITokenRepository tokenRepository;

  ApiClient(this.tokenRepository) {
    final baseOptions = BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com/",
      responseType: ResponseType.json,
    );

    dio = Dio(baseOptions);

    dio.interceptors.addAll([
      // PrettyDioLogger(
      //   responseBody: false,
      //   requestHeader: true,
      // ),
      LoggingInterceptor(),
      AuthInterceptor(dio: dio, tokenRepository: tokenRepository),
    ]);
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(String url, dynamic data) async {
    return dio.post(url, data: data);
  }

  Future<Response<T>> put<T>(String url, dynamic data) async {
    return dio.put(url, data: data);
  }

  Future<Response<T>> delete<T>(String url) async {
    return dio.delete(url);
  }

  Future<Response<T>> patch<T>(String url, dynamic data) async {
    return dio.patch(url, data: data);
  }

  Future<Response> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    return dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
  }
}

// class TokenRepository {
//   getAccessToken() async {
//     String? accessToken = await storage.read(key: "accessToken");

//     return accessToken;
//   }

//   getAccessTokenRemainingTime() {
//     return const Duration(seconds: 150);
//   }
// }

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final ITokenRepository tokenRepository;

  AuthInterceptor({required this.dio, required this.tokenRepository});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await tokenRepository.getAccessToken();

    if (accessToken != null) {
      // final expiration = repo.getAccessTokenRemainingTime();

      // if (expiration.inSeconds <= 30) {
      //   // call endpoint to get refresh token
      // final refreshToken = await tokenRepository.getRefreshToken();
      // }

      options.headers['Authorisation'] = "Bearer $accessToken";
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      logger.w('the token has expired, need to receive new token');
      // call endpoint to get refresh token
    }

    super.onError(err, handler);
  }
}
