import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lumiere/core/storage/auth_tokens.dart';

class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage storage;

  static const accessKey = 'access_token';
  static const refreshKey = 'refresh_token';

  Future<void> save(AuthTokens tokens) async {
    await storage.write(key: accessKey, value: tokens.accessToken);
    if (tokens.refreshToken.isNotEmpty) {
      await storage.write(key: refreshKey, value: tokens.refreshToken);
    }
  }

  Future<String?> getAccessToken() => storage.read(key: accessKey);

  Future<String?> getRefreshToken() => storage.read(key: refreshKey);

  Future<bool> hasSession() async => (await getRefreshToken()) != null;

  Future<void> clear() => storage.deleteAll();
}