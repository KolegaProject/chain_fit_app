import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chain_fit_app/core/enums/view_state.dart';
import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/features/qr_code/viewmodels/list_qr_viewmodel.dart';
import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';

class MockApiService extends Mock implements ApiService {}
class MockCacheService extends Mock implements CacheService {}
class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'BASE_URL=https://api.example.com');
  });

  late ListQrViewModel listQrViewModel;
  late MockApiService mockApiService;
  late MockCacheService mockCacheService;
  late MockDio mockDio;

  setUp(() {
    mockApiService = MockApiService();
    mockCacheService = MockCacheService();
    mockDio = MockDio();

    when(() => mockApiService.client).thenReturn(mockDio);
    listQrViewModel = ListQrViewModel(
      apiService: mockApiService,
      cacheService: mockCacheService,
    );
  });

  final tApiResponse = {
    'data': [
      {
        'id': 1,
        'startDate': '2026-06-01',
        'endDate': '2026-06-30',
        'status': 'AKTIF',
        'gym': {
          'id': 10,
          'name': 'Gym Central',
          'address': 'Jl. Central No. 1'
        },
        'package': {
          'id': 101,
          'name': 'Monthly Pass',
          'price': '300000',
          'durationDays': 30
        }
      }
    ]
  };

  final tCacheData = {
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'data': {
      'data': [
        {
          'id': 1,
          'startDate': '2026-06-01',
          'endDate': '2026-06-30',
          'status': 'AKTIF',
          'gym': {
            'id': 10,
            'name': 'Gym Central',
            'address': 'Jl. Central No. 1'
          },
          'package': {
            'id': 101,
            'name': 'Monthly Pass',
            'price': '300000',
            'durationDays': 30
          }
        }
      ]
    }
  };

  group('ListQrViewModel Test Suite', () {
    test('Test Case 1: Mencegah Race Condition / Spam Click (Baru)', () async {
      // Arrange
      // Mock API call to delay response
      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => null);
      
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return Response(
              requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
              data: tApiResponse,
              statusCode: 200,
            );
          });

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse))
          .thenAnswer((_) async {});

      // Act
      final Future<void> firstCall = listQrViewModel.loadMemberships();
      final Future<void> secondCall = listQrViewModel.loadMemberships();

      await Future.wait([firstCall, secondCall]);

      // Assert
      // The API call should only be made once
      verify(() => mockDio.get(ApiConstants.activePackageEndpoint)).called(1);
    });

    test('Test Case 2: Gunakan Cache (False), Cache KOSONG, & API Sukses (Baru)', () async {
      // Arrange
      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => null);
      
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
            data: tApiResponse,
            statusCode: 200,
          ));

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse))
          .thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      expect(listQrViewModel.isLoading, isFalse);
      expect(listQrViewModel.isRefetching, isFalse);
      expect(listQrViewModel.errorMessage, isNull);
      expect(listQrViewModel.memberships.length, equals(1));
      expect(listQrViewModel.memberships[0].gym.name, equals('Gym Central'));
      expect(listQrViewModel.state, equals(ViewState.success));

      verify(() => mockCacheService.getCache(ApiConstants.packageCacheKey)).called(1);
      verify(() => mockDio.get(ApiConstants.activePackageEndpoint)).called(1);
      verify(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse)).called(1);
    });

    test('Test Case 3: Force Refresh (True) & API Sukses (Diperbarui)', () async {
      // Arrange
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
            data: tApiResponse,
            statusCode: 200,
          ));

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse))
          .thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: true);

      // Assert
      expect(listQrViewModel.isLoading, isFalse);
      expect(listQrViewModel.isRefetching, isFalse);
      expect(listQrViewModel.errorMessage, isNull);
      expect(listQrViewModel.memberships.length, equals(1));
      expect(listQrViewModel.state, equals(ViewState.success));

      // Shoud not try to fetch cache
      verifyNever(() => mockCacheService.getCache(any()));
      verify(() => mockDio.get(ApiConstants.activePackageEndpoint)).called(1);
      verify(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse)).called(1);
    });

    test('Test Case 4: Gunakan Cache (False), Cache ADA, & API Sukses (Diperbarui)', () async {
      // Arrange
      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => tCacheData);
      
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
            data: tApiResponse,
            statusCode: 200,
          ));

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse))
          .thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      expect(listQrViewModel.isLoading, isFalse);
      expect(listQrViewModel.isRefetching, isFalse);
      expect(listQrViewModel.errorMessage, isNull);
      expect(listQrViewModel.memberships.length, equals(1));
      expect(listQrViewModel.state, equals(ViewState.success));

      verify(() => mockCacheService.getCache(ApiConstants.packageCacheKey)).called(1);
      verify(() => mockDio.get(ApiConstants.activePackageEndpoint)).called(1);
      verify(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse)).called(1);
    });

    test('Test Case 5: API Error - Data Tidak Ditemukan / 404 (Diperbarui)', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
        response: Response(
          requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => null);
      
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenThrow(dioError);

      when(() => mockApiService.isNotFoundError(dioError)).thenReturn(true);
      when(() => mockCacheService.removeCache(ApiConstants.packageCacheKey)).thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      expect(listQrViewModel.memberships, isEmpty);
      expect(listQrViewModel.errorMessage, isNull);
      expect(listQrViewModel.state, equals(ViewState.empty));

      verify(() => mockCacheService.removeCache(ApiConstants.packageCacheKey)).called(1);
    });

    test('Test Case 6: API Error General & Cache Kosong (Kondisi Kritis)', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
        response: Response(
          requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => null);
      
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenThrow(dioError);

      when(() => mockApiService.isNotFoundError(dioError)).thenReturn(false);

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      expect(listQrViewModel.memberships, isEmpty);
      expect(listQrViewModel.errorMessage, equals('Gagal memuat data membership. Periksa koneksi Anda.'));
      expect(listQrViewModel.state, equals(ViewState.error));
    });

    test('Test Case 7: API Error General, TAPI Cache Ada (Graceful Degradation)', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
        response: Response(
          requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      // Mock cache returning valid data
      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => tCacheData);
      
      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenThrow(dioError);

      when(() => mockApiService.isNotFoundError(dioError)).thenReturn(false);

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      // Cached data should be preserved, no error shown (graceful degradation)
      expect(listQrViewModel.memberships.length, equals(1));
      expect(listQrViewModel.errorMessage, isNull);
      expect(listQrViewModel.state, equals(ViewState.success));
    });

    test('Test Case 8: Default constructor initialization (fallbacks)', () {
      final vm = ListQrViewModel();
      expect(vm.memberships, isEmpty);
      expect(vm.isLoading, isFalse);
      expect(vm.isRefetching, isFalse);
      expect(vm.errorMessage, isNull);
    });

    test('Test Case 9: Cache throws exception in _loadFromDashboardCache', () async {
      // Arrange
      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenThrow(Exception('Cache error'));

      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
            data: tApiResponse,
            statusCode: 200,
          ));

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse))
          .thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      // Should catch the error silently and continue to API fetch
      expect(listQrViewModel.memberships.length, equals(1));
      expect(listQrViewModel.state, equals(ViewState.success));
      verify(() => mockCacheService.getCache(ApiConstants.packageCacheKey)).called(1);
    });

    test('Test Case 10: API Response data contains null for key "data" fallback', () async {
      // Arrange
      final nullDataApiResponse = {
        'data': null
      };

      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => null);

      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
            data: nullDataApiResponse,
            statusCode: 200,
          ));

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, nullDataApiResponse))
          .thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      // Fallback ?? [] should be triggered, resulting in empty memberships
      expect(listQrViewModel.memberships, isEmpty);
      expect(listQrViewModel.state, ViewState.empty);
    });

    test('Test Case 11: Cache data contains null for key "data" fallback', () async {
      // Arrange
      final nullDataCacheResponse = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': {
          'data': null
        }
      };

      when(() => mockCacheService.getCache(ApiConstants.packageCacheKey))
          .thenAnswer((_) async => nullDataCacheResponse);

      when(() => mockDio.get(ApiConstants.activePackageEndpoint))
          .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.activePackageEndpoint),
            data: tApiResponse,
            statusCode: 200,
          ));

      when(() => mockCacheService.saveCache(ApiConstants.packageCacheKey, tApiResponse))
          .thenAnswer((_) async {});

      // Act
      await listQrViewModel.loadMemberships(forceRefresh: false);

      // Assert
      // Fallback ?? [] should be triggered for cache load, memberships initially empty,
      // then API successfully loads tApiResponse data
      expect(listQrViewModel.memberships.length, equals(1));
      expect(listQrViewModel.state, ViewState.success);
    });
  });
}
