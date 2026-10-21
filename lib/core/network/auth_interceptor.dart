import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lumiere/core/network/api_constants.dart';
import 'package:lumiere/core/storage/auth_tokens.dart';
import 'package:lumiere/core/storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required VoidCallback onSessionExpired,
  })  : storage = tokenStorage,
        onSessionExpired = onSessionExpired,
        plainDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout:  Duration(seconds: 15),
            receiveTimeout:  Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        );

  final TokenStorage storage;
  final VoidCallback onSessionExpired;

  final Dio plainDio;

  bool isPublic(String path) {
    final normalizedPath =
        path.startsWith('/') ? path.substring(1) : path;

    return ApiConstants.publicAuthPaths.contains(normalizedPath);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!isPublic(options.path)) {
      final token = await storage.getAccessToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        isPublic(options.path)) {
      return handler.next(err);
    }

    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) {
      await expire();
      return handler.next(err);
    }

    final currentAccess = await storage.getAccessToken();

    if (currentAccess != null &&
        options.headers['Authorization'] !=
            'Bearer $currentAccess') {
      return retry(
        options,
        currentAccess,
        handler,
        err,
      );
    }

    try {
      final response = await plainDio.post(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
          'useCookies': false,
        },
      );

      final tokens = AuthTokens.fromJson(
        response.data as Map<String, dynamic>,
      );

      await storage.save(tokens);

      return retry(
        options,
        tokens.accessToken,
        handler,
        err,
      );
    } catch (_) {
      await expire();
      return handler.next(err);
    }
  }

  Future<void> retry(
    RequestOptions options,
    String accessToken,
    ErrorInterceptorHandler handler,
    DioException original,
  ) async {
    options.headers['Authorization'] = 'Bearer $accessToken';

    try {
      final response = await plainDio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<void> expire() async {
    await storage.clear();
    onSessionExpired();
  }
}
