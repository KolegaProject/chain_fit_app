import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';

  // --- Simpan kedua token sekaligus
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // --- READ ---
  // Ambil Access Token (Untuk Header Request)
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Ambil Refresh Token (Untuk memperbarui Access Token jika expired)
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // --- CHECK ---
  // Cek apakah user sedang login (punya access token)
  Future<bool> hasToken() async {
    var token = await _storage.read(key: _accessTokenKey);
    return token != null;
  }

  // --- DELETE (LOGOUT) ---
  // Hapus semua token saat user logout
  Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
