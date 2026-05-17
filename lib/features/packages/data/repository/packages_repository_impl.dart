import 'package:dio/dio.dart';
import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/data/mapper/package_dto_mapper.dart';
import 'package:sensei/features/packages/data/remote/api/packages_api.dart';
import 'package:sensei/features/packages/domain/model/package_model.dart';
import 'package:sensei/features/packages/domain/repository/packages_repository.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  PackagesRepositoryImpl({required PackagesApi api}) : _api = api;

  final PackagesApi _api;

  @override
  Future<Resource<List<PackageModel>>> getPackagesByStatus({
    required int statusId,
    required int companyId,
    required int branchId,
  }) async {
    try {
      final response = await _api.getPackagesByStatus(
        statusId: statusId,
        companyId: companyId,
        branchId: branchId,
      );
      if (response.statusCode == 1 && response.data != null) {
        final packages =
            response.data!.packages.map((dto) => dto.toDomain()).toList();
        return Resource.success(packages);
      }
      return Resource.error(
        ServerError(code: response.statusCode ?? 0, message: response.msg),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Resource.error(UnknownError(originalError: e));
    }
  }

  @override
  Future<Resource<void>> addSample(int packageId, String barcode) async {
    try {
      final response = await _api.addSample(packageId, barcode);
      if (response.statusCode == 1) {
        return const ResourceSuccess(null);
      }
      return Resource.error(
        ServerError(code: response.statusCode ?? 0, message: response.msg),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Resource.error(UnknownError(originalError: e));
    }
  }

  @override
  Future<Resource<void>> updatePackageStatus(
      int packageId, int statusId) async {
    try {
      final response = await _api.updatePackageStatus(packageId, statusId);
      if (response.statusCode == 1) {
        return const ResourceSuccess(null);
      }
      return Resource.error(
        ServerError(code: response.statusCode ?? 0, message: response.msg),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Resource.error(UnknownError(originalError: e));
    }
  }

  @override
  Future<Resource<void>> sendPackage(int packageId) async {
    try {
      final response = await _api.sendPackage(packageId);
      if (response.statusCode == 1) {
        return const ResourceSuccess(null);
      }
      return Resource.error(
        ServerError(code: response.statusCode ?? 0, message: response.msg),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Resource.error(UnknownError(originalError: e));
    }
  }

  Resource<T> _handleDioError<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const ResourceError(NetworkError());
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      return const ResourceError(UnauthorizedError());
    }
    return Resource.error(
      ServerError(code: statusCode ?? 0, message: e.message),
    );
  }
}
