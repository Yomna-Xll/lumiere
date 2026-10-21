import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lumiere/core/network/api_constants.dart';
import 'package:lumiere/core/network/auth_interceptor.dart';
import 'package:lumiere/core/storage/token_storage.dart';

class DioClient {
  DioClient._();

  static Dio create({
    required TokenStorage tokenStorage,
    required VoidCallback onSessionExpired,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:  Duration(seconds: 15),
        receiveTimeout:  Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        onSessionExpired: onSessionExpired,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    return dio;
  }
}