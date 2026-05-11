import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/enhancement_response.dart';

class ReplicateApi {
  final Dio _dio;

  ReplicateApi(this._dio);

  Future<EnhancementResponse> createPrediction({
    required String modelVersion,
    required Map<String, dynamic> input,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.predictions,
        data: {
          'version': modelVersion,
          'input': input,
        },
      );
      return EnhancementResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<EnhancementResponse> getPrediction(String id) async {
    try {
      final response = await _dio.get(ApiConstants.prediction(id));
      return EnhancementResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> cancelPrediction(String id) async {
    try {
      await _dio.post(ApiConstants.cancelPrediction(id));
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
