import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:chain_fit_app/features/qr_code/viewmodels/detail_qr_viewmodel.dart';
import 'package:chain_fit_app/core/services/api_service.dart';

// Mocking dependencies
class MockApiService extends Mock implements ApiService {}

class MockDio extends Mock implements Dio {}

void main() {
  late DetailQrViewModel detailQrViewModel;
  late MockApiService mockApiService;
  late MockDio mockDio;

  setUp(() {
    mockApiService = MockApiService();
    mockDio = MockDio();

    // Set client in mockApiService to return mockDio
    when(() => mockApiService.client).thenReturn(mockDio);

    detailQrViewModel = DetailQrViewModel(
      apiService: mockApiService,
    );
  });

  group('DetailQrViewModel - White Box Testing (generateQrToken)', () {
    const tMembershipId = 123;
    const tEndpoint = '/api/v1/attendance/$tMembershipId/qr/me';

    test('1. Happy Path - Success generate and refresh QR token', () async {
      // Arrange
      final responseData = {
        'data': {
          'token': {
            'token': 'mock_qr_token_abcd1234',
            'memberId': 'mock_member_id_999',
          }
        }
      };

      when(
        () => mockDio.post(tEndpoint),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: tEndpoint),
          data: responseData,
          statusCode: 200,
        ),
      );

      final List<bool> loadingStates = [];
      detailQrViewModel.addListener(() {
        loadingStates.add(detailQrViewModel.isLoading);
      });

      // Act
      await detailQrViewModel.generateQrToken(tMembershipId);

      // Assert
      expect(detailQrViewModel.isLoading, isFalse);
      expect(detailQrViewModel.errorMessage, isNull);
      expect(detailQrViewModel.hasError, isFalse);
      expect(detailQrViewModel.hasData, isTrue);
      expect(detailQrViewModel.qrToken, isNotNull);
      expect(detailQrViewModel.qrToken!.token, equals('mock_qr_token_abcd1234'));
      expect(detailQrViewModel.qrToken!.memberId, equals('mock_member_id_999'));

      // Check state transitions
      expect(loadingStates, contains(true));
      expect(loadingStates.last, isFalse);

      verify(() => mockDio.post(tEndpoint)).called(1);
    });

    test('2. Negative Path - Fail on DioException (e.g. server error or unauthorized)', () async {
      // Arrange
      when(
        () => mockDio.post(tEndpoint),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: tEndpoint),
          response: Response(
            requestOptions: RequestOptions(path: tEndpoint),
            statusCode: 500,
            data: {'message': 'Internal Server Error'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      await detailQrViewModel.generateQrToken(tMembershipId);

      // Assert
      expect(detailQrViewModel.isLoading, isFalse);
      expect(detailQrViewModel.hasError, isTrue);
      expect(detailQrViewModel.hasData, isFalse);
      expect(detailQrViewModel.qrToken, isNull);
      expect(detailQrViewModel.errorMessage, isNotNull);

      verify(() => mockDio.post(tEndpoint)).called(1);
    });

    test('3. Negative Path - Fail on Generic Exception', () async {
      // Arrange
      when(
        () => mockDio.post(tEndpoint),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      await detailQrViewModel.generateQrToken(tMembershipId);

      // Assert
      expect(detailQrViewModel.isLoading, isFalse);
      expect(detailQrViewModel.hasError, isTrue);
      expect(detailQrViewModel.hasData, isFalse);
      expect(detailQrViewModel.qrToken, isNull);
      expect(detailQrViewModel.errorMessage, contains('Unexpected error'));

      verify(() => mockDio.post(tEndpoint)).called(1);
    });
  });

  group('DetailQrViewModel - reset', () {
    test('Should clear all data, error, and loading states', () {
      // Arrange
      // Let's call reset and ensure everything goes back to clean state
      detailQrViewModel.reset();

      // Assert
      expect(detailQrViewModel.qrToken, isNull);
      expect(detailQrViewModel.errorMessage, isNull);
      expect(detailQrViewModel.isLoading, isFalse);
      expect(detailQrViewModel.hasError, isFalse);
      expect(detailQrViewModel.hasData, isFalse);
    });
  });
}
