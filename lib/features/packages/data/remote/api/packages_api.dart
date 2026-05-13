import 'package:dio/dio.dart';
import 'package:sensei/features/packages/data/remote/dto/package_response_dto.dart';

class PackagesApi {
  PackagesApi({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<PackageResponseDto> getPackagesByStatus(int statusId) async {
    final response = await _dio.get(
      '/api/packages/WithStatus',
      queryParameters: {'statusId': statusId},
    );
    return PackageResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<GenericResponseDto> addSample(int packageId, String barcode) async {
    final response = await _dio.post(
      '/api/packages/AddSample',
      data: {
        'PackageID': packageId,
        'Barcode': barcode,
      },
    );
    return GenericResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<GenericResponseDto> updatePackageStatus(
      int packageId, int statusId) async {
    final response = await _dio.put(
      '/api/packages/UpdateStatus',
      data: {
        'PackageID': packageId,
        'StatusID': statusId,
      },
    );
    return GenericResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Note: typo "SendPacakge" preserved from original API.
  Future<GenericResponseDto> sendPackage(int packageId) async {
    final response = await _dio.post(
      '/api/packages/SendPacakge',
      data: {
        'PackageID': packageId,
      },
    );
    return GenericResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }
}
