import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';
import 'package:chain_fit_app/core/services/storage_service.dart';
import 'package:flutter/material.dart';

class AuthLogout {
  final StorageService _storage = StorageService();
  final CacheService _cache = CacheService();

  Future<void> logout() async {
    await _storage.logout();

    await _cache.removeCache(ApiConstants.profileCacheKey);
    await _cache.removeCache(ApiConstants.packageCacheKey);
    await _cache.removeCache(ApiConstants.userLocationCacheKey);

  }
}
