import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_revive_ai/core/errors/exceptions.dart';
import 'package:photo_revive_ai/features/enhance/data/datasources/replicate_api.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockDio mockDio;
  late ReplicateApi api;

  setUp(() {
    mockDio = MockDio();
    api = ReplicateApi(mockDio);
  });

  group('createPrediction', () {
    test('posts to /predictions with correct body', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: TestData.processingJson,
            statusCode: 201,
            requestOptions: RequestOptions(),
          ));

      final result = await api.createPrediction(
        modelVersion: 'test-version',
        input: {'image': 'data:image/jpeg;base64,abc'},
      );

      expect(result.id, 'test-123');
      expect(result.status, 'processing');

      verify(() => mockDio.post(
            '/predictions',
            data: {
              'version': 'test-version',
              'input': {'image': 'data:image/jpeg;base64,abc'},
            },
          )).called(1);
    });

    test('throws ServerException on 4xx', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: {'detail': 'Invalid token'},
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => api.createPrediction(modelVersion: 'v', input: {}),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws ServerException on 5xx', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: {'error': 'Internal error'},
            statusCode: 500,
            requestOptions: RequestOptions(),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => api.createPrediction(modelVersion: 'v', input: {}),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPrediction', () {
    test('parses success JSON', () async {
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            data: TestData.successJson,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final result = await api.getPrediction('test-123');
      expect(result.status, 'succeeded');
      expect(result.outputUrl, 'https://example.com/result.jpg');
    });

    test('parses failure JSON', () async {
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            data: TestData.failedJson,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final result = await api.getPrediction('test-123');
      expect(result.status, 'failed');
      expect(result.error, 'Model failed');
    });
  });
}
