class ApiConstants {
  // Ini key untuk cache lokal
  static const String profileCacheKey = 'CACHE_PROFILE';
  static const String packageCacheKey = 'CACHE_PACKAGES';

  // Ini endpoint path-nya
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String userProfileEndpoint = '/api/v1/auth/me';
  static const String activePackageEndpoint = '/api/v1/gym/me/memberships';
}
