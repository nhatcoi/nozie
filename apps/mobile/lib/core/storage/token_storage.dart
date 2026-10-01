import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the JWT pair in the platform keystore (Keychain / EncryptedSharedPreferences),
/// never in SharedPreferences. A small in-memory cache avoids a keystore hit per request.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const _kAccess = 'auth.access_token';
  static const _kRefresh = 'auth.refresh_token';

  final FlutterSecureStorage _storage;
  String? _access;
  String? _refresh;
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _access = await _storage.read(key: _kAccess);
    _refresh = await _storage.read(key: _kRefresh);
    _loaded = true;
  }

  Future<String?> readAccessToken() async {
    await _ensureLoaded();
    return _access;
  }

  Future<String?> readRefreshToken() async {
    await _ensureLoaded();
    return _refresh;
  }

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _access = accessToken;
    _refresh = refreshToken;
    _loaded = true;
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _loaded = true;
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}
