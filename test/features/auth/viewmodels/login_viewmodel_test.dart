import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:chain_fit_app/features/auth/viewmodels/login_viewmodel.dart';
import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/core/services/storage_service.dart';
import 'package:chain_fit_app/core/constants/api_constants.dart';

// Mocking dependencies
class MockApiService extends Mock implements ApiService {}

class MockStorageService extends Mock implements StorageService {}

class MockDio extends Mock implements Dio {}

void main() {
  late LoginViewModel loginViewModel;
  late MockApiService mockApiService;
  late MockStorageService mockStorageService;
  late MockDio mockDio;

  setUp(() {
    mockApiService = MockApiService();
    mockStorageService = MockStorageService();
    mockDio = MockDio();

    // Mengatur agar apiService.client mengembalikan mockDio
    when(() => mockApiService.client).thenReturn(mockDio);

    loginViewModel = LoginViewModel(
      apiService: mockApiService,
      storageService: mockStorageService,
    );
  });

  group('LoginViewModel - White Box Testing (login)', () {
    const tUsername = 'udinjago';
    const tPassword = 'Udin12345!';
    const tRequestBody = {'username': tUsername, 'password': tPassword};

    test('1. Success Path (Semua cabang sukses dijalankan)', () async {
      // Arrange
      final responseData = {
        'data': {
          'access_token': 'valid_access_token',
          'refresh_token': 'valid_refresh_token',
        },
      };

      when(
        () => mockDio.post(ApiConstants.loginEndpoint, data: tRequestBody),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
          data: responseData,
          statusCode: 200,
        ),
      );

      when(
        () => mockStorageService.saveTokens(
          accessToken: 'valid_access_token',
          refreshToken: 'valid_refresh_token',
        ),
      ).thenAnswer((_) async => {});

      // Ambil riwayat perubahan isLoading
      final List<bool> loadingStates = [];
      loginViewModel.addListener(() {
        loadingStates.add(loginViewModel.isLoading);
      });

      // Act
      final result = await loginViewModel.login(tUsername, tPassword);

      // Assert
      expect(result, isTrue);
      expect(loginViewModel.errorMessage, isNull);
      expect(loginViewModel.isLoading, isFalse);

      // Verifikasi control flow state loading:
      // loginViewModel diset true di awal, lalu kembali false di blok finally.
      expect(loadingStates, contains(true));
      expect(loadingStates.last, isFalse);

      verify(
        () => mockDio.post(ApiConstants.loginEndpoint, data: tRequestBody),
      ).called(1);
      verify(
        () => mockStorageService.saveTokens(
          accessToken: 'valid_access_token',
          refreshToken: 'valid_refresh_token',
        ),
      ).called(1);
    });

    test(
      '2. DioException Path - Response data memiliki pesan error yang valid',
      () async {
        // Arrange
        final errorResponseData = {
          'errors': {'message': 'Username atau password salah'},
        };

        when(
          () => mockDio.post(
            ApiConstants.loginEndpoint,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
            response: Response(
              requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
              statusCode: 401,
              data: errorResponseData,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act
        final result = await loginViewModel.login(tUsername, tPassword);

        // Assert
        expect(result, isFalse);
        expect(
          loginViewModel.errorMessage,
          equals('Username atau password salah'),
        );
        expect(loginViewModel.isLoading, isFalse);

        verify(
          () => mockDio.post(ApiConstants.loginEndpoint, data: tRequestBody),
        ).called(1);
        verifyNever(
          () => mockStorageService.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      },
    );

    test(
      '3. DioException Path - Response data ada tetapi format error message null (Fallback: Login gagal)',
      () async {
        // Arrange
        final incompleteResponseData = {'errors': null};

        when(
          () => mockDio.post(
            ApiConstants.loginEndpoint,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
            response: Response(
              requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
              statusCode: 400,
              data: incompleteResponseData,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act
        final result = await loginViewModel.login(tUsername, tPassword);

        // Assert
        expect(result, isFalse);
        expect(loginViewModel.errorMessage, equals('Login gagal'));
        expect(loginViewModel.isLoading, isFalse);

        verify(
          () => mockDio.post(ApiConstants.loginEndpoint, data: tRequestBody),
        ).called(1);
      },
    );

    test(
      '4. DioException Path - Response / Response data bernilai null (Server offline atau timeout)',
      () async {
        // Arrange
        when(
          () => mockDio.post(
            ApiConstants.loginEndpoint,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiConstants.loginEndpoint),
            response: null,
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act
        final result = await loginViewModel.login(tUsername, tPassword);

        // Assert
        expect(result, isFalse);
        expect(
          loginViewModel.errorMessage,
          equals('Tidak dapat terhubung ke server'),
        );
        expect(loginViewModel.isLoading, isFalse);

        verify(
          () => mockDio.post(ApiConstants.loginEndpoint, data: tRequestBody),
        ).called(1);
      },
    );

    test(
      '5. Generic Exception Path (Mencakup penanganan catch general)',
      () async {
        // Arrange
        when(
          () => mockDio.post(
            ApiConstants.loginEndpoint,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('Format response salah'));

        // Act
        final result = await loginViewModel.login(tUsername, tPassword);

        // Assert
        expect(result, isFalse);
        expect(
          loginViewModel.errorMessage,
          equals('Error: Exception: Format response salah'),
        );
        expect(loginViewModel.isLoading, isFalse);

        verify(
          () => mockDio.post(ApiConstants.loginEndpoint, data: tRequestBody),
        ).called(1);
      },
    );
  });

  group('LoginViewModel - clearError', () {
    test('Harus berhasil mengosongkan state errorMessage', () async {
      // Arrange (buat state error terlebih dahulu dengan mensimulasikan generic error)
      when(
        () =>
            mockDio.post(ApiConstants.loginEndpoint, data: any(named: 'data')),
      ).thenThrow(Exception('Test error'));
      await loginViewModel.login('user', 'pass');
      expect(loginViewModel.errorMessage, isNotNull);

      // Act
      loginViewModel.clearError();

      // Assert
      expect(loginViewModel.errorMessage, isNull);
    });
  });
}
