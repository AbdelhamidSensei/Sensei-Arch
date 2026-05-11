import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final message = err.response?.data?['detail'] ??
        err.response?.data?['error'] ??
        err.message ??
        'Unknown error';

    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerException(message.toString(), statusCode: statusCode),
          type: err.type,
          response: err.response,
        ),
      );
    } else if (statusCode != null && statusCode >= 500) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerException(
            '$message (retry later)',
            statusCode: statusCode,
          ),
          type: err.type,
          response: err.response,
        ),
      );
    } else {
      handler.next(err);
    }
  }
}
