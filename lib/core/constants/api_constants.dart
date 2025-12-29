class ApiConstants {
  // Ini key untuk cache lokal
  static const String profileCacheKey = 'CACHE_PROFILE';
  static const String packageCacheKey = 'CACHE_PACKAGES';
  
  static String gymDetailCacheKey(int gymId) => 'CACHE_GYM_DETAIL_$gymId';
  static String gymPackageCacheKey(int gymId) => 'CACHE_GYM_PACKAGE_$gymId';

  // Ini endpoint path-nya
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String userProfileEndpoint = '/api/v1/auth/me';
  static const String activePackageEndpoint = '/api/v1/gym/me/memberships';
  static const String searchGymEndpoint = '/api/v1/gym';

  static String gymDetailEndpoint(int gymId) => '/api/v1/gym/$gymId';
  static String gymPackageEndpoint(int gymId) => '/api/v1/gym/$gymId/paket-member';
}
