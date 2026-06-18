import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:chain_fit_app/core/enums/view_state.dart';
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
      final List<ViewState> viewStates = [];
      detailQrViewModel.addListener(() {
        loadingStates.add(detailQrViewModel.isLoading);
        viewStates.add(detailQrViewModel.state);
      });

      // Initial state
      expect(detailQrViewModel.state, equals(ViewState.empty));

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
      expect(detailQrViewModel.state, equals(ViewState.success));

      // Check state transitions
      expect(loadingStates, contains(true));
      expect(loadingStates.last, isFalse);
      expect(viewStates, contains(ViewState.loading));
      expect(viewStates.last, equals(ViewState.success));

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

      final List<ViewState> viewStates = [];
      detailQrViewModel.addListener(() {
        viewStates.add(detailQrViewModel.state);
      });

      // Initial state
      expect(detailQrViewModel.state, equals(ViewState.empty));

      // Act
      await detailQrViewModel.generateQrToken(tMembershipId);

      // Assert
      expect(detailQrViewModel.isLoading, isFalse);
      expect(detailQrViewModel.hasError, isTrue);
      expect(detailQrViewModel.hasData, isFalse);
      expect(detailQrViewModel.qrToken, isNull);
      expect(detailQrViewModel.errorMessage, isNotNull);
      expect(detailQrViewModel.state, equals(ViewState.error));

      // Check state transitions
      expect(viewStates, contains(ViewState.loading));
      expect(viewStates.last, equals(ViewState.error));

      verify(() => mockDio.post(tEndpoint)).called(1);
    });

    test('3. Negative Path - Fail on Generic Exception', () async {
      // Arrange
      when(
        () => mockDio.post(tEndpoint),
      ).thenThrow(Exception('Unexpected error'));

      final List<ViewState> viewStates = [];
      detailQrViewModel.addListener(() {
        viewStates.add(detailQrViewModel.state);
      });

      // Initial state
      expect(detailQrViewModel.state, equals(ViewState.empty));

      // Act
      await detailQrViewModel.generateQrToken(tMembershipId);

      // Assert
      expect(detailQrViewModel.isLoading, isFalse);
      expect(detailQrViewModel.hasError, isTrue);
      expect(detailQrViewModel.hasData, isFalse);
      expect(detailQrViewModel.qrToken, isNull);
      expect(detailQrViewModel.errorMessage, contains('Unexpected error'));
      expect(detailQrViewModel.state, equals(ViewState.error));

      // Check state transitions
      expect(viewStates, contains(ViewState.loading));
      expect(viewStates.last, equals(ViewState.error));

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
      expect(detailQrViewModel.state, equals(ViewState.empty));
    });
  });
}
