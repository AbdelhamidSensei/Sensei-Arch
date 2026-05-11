import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/file_utils.dart';

class RemoveBgApi {
  static const _baseUrl = 'https://api.remove.bg/v1.0/removebg';

  final String _apiKey;
  final Dio _dio;

  RemoveBgApi(this._apiKey) : _dio = Dio();

  Future<String> removeBackground(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _dio.post(
        _baseUrl,
        data: {
          'image_file_b64': base64Image,
          'size': 'auto',
          'format': 'png',
        },
        options: Options(
          headers: {'X-Api-Key': _apiKey},
          responseType: ResponseType.bytes,
        ),
      );

      return FileUtils.saveBytesToCache(response.data, extension: 'png');
    } on DioException catch (e) {
      final msg = e.response?.data != null
          ? utf8.decode(e.response!.data as List<int>)
          : e.message ?? 'Remove.bg API error';
      throw ServerException(msg, statusCode: e.response?.statusCode);
    }
  }
}
