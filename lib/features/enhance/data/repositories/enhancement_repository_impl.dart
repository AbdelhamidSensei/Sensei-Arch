import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;

import '../../../../core/config/app_config.dart';
import '../../../../core/config/env.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/file_utils.dart';
import '../../domain/entities/enhancement_job.dart';
import '../../domain/repositories/enhancement_repository.dart';
import '../datasources/removebg_api.dart';
import '../datasources/replicate_api.dart';
import '../models/enhancement_request.dart';

class EnhancementRepositoryImpl implements EnhancementRepository {
  final ReplicateApi _api;
  final NetworkInfo _networkInfo;

  EnhancementRepositoryImpl(this._api, this._networkInfo);

  @override
  Future<EnhancementJob> startEnhancement({
    required String localImagePath,
    required EnhancementMode mode,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    // Background removal uses Remove.bg directly (not Replicate)
    if (mode == EnhancementMode.removeBackground) {
      return _handleRemoveBackground(localImagePath);
    }

    final base64 = await FileUtils.imageToBase64(localImagePath);
    final dataUri = FileUtils.toDataUri(base64);

    final request = EnhancementRequest(imageBase64: dataUri, mode: mode);

    final modelVersion = switch (mode) {
      EnhancementMode.enhance => Env.enhanceModelVersion,
      EnhancementMode.restoreFace => Env.restoreModelVersion,
      EnhancementMode.colorize => Env.restoreModelVersion,
      EnhancementMode.removeWatermark => Env.lamaModelVersion,
      EnhancementMode.removeBackground => '', // handled above
    };

    final response = await _api.createPrediction(
      modelVersion: modelVersion,
      input: request.toInputJson(),
    );

    return EnhancementJob(
      id: response.id,
      status: response.status,
      outputUrl: response.outputUrl,
      error: response.error,
      mode: mode,
    );
  }

  Future<EnhancementJob> _handleRemoveBackground(String imagePath) async {
    if (!Env.hasRemoveBgKey) {
      throw const ServerException('Remove.bg API key not configured');
    }
    final removeBg = RemoveBgApi(Env.removeBgApiKey);
    final resultPath = await removeBg.removeBackground(imagePath);
    return EnhancementJob(
      id: 'removebg-${DateTime.now().millisecondsSinceEpoch}',
      status: 'succeeded',
      outputUrl: resultPath,
      mode: EnhancementMode.removeBackground,
    );
  }

  @override
  Stream<EnhancementJob> pollStatus(
      String predictionId, EnhancementMode mode) async* {
    // Remove.bg returns instantly — no polling needed
    if (mode == EnhancementMode.removeBackground) return;

    final stopwatch = Stopwatch()..start();
    const timeout = Duration(milliseconds: AppConfig.pollTimeoutMs);
    const interval = Duration(milliseconds: AppConfig.pollIntervalMs);

    while (stopwatch.elapsed < timeout) {
      await Future<void>.delayed(interval);

      final response = await _api.getPrediction(predictionId);
      final job = EnhancementJob(
        id: response.id,
        status: response.status,
        outputUrl: response.outputUrl,
        error: response.error,
        mode: mode,
      );

      yield job;

      if (job.isTerminal) return;
    }

    throw const ServerException('Enhancement timed out');
  }

  @override
  Future<String> downloadResultToCache(String url) async {
    // If it's already a local path (e.g. from Remove.bg), just return it
    if (url.startsWith('/') || url.contains(':\\') || url.contains('/data/')) {
      return url;
    }
    final dio = Dio();
    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return FileUtils.saveBytesToCache(response.data!);
  }
}

/// Mock implementation for offline/no-token testing.
/// Applies visible image effects so the before/after difference is obvious.
class MockEnhancementRepository implements EnhancementRepository {
  String? _inputPath;

  @override
  Future<EnhancementJob> startEnhancement({
    required String localImagePath,
    required EnhancementMode mode,
  }) async {
    _inputPath = localImagePath;
    return EnhancementJob(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      status: 'starting',
      mode: mode,
    );
  }

  @override
  Stream<EnhancementJob> pollStatus(
      String predictionId, EnhancementMode mode) async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield EnhancementJob(
        id: predictionId, status: 'processing', mode: mode);

    // Apply the mock effect
    final resultPath = await _applyMockEffect(_inputPath!, mode);

    await Future<void>.delayed(const Duration(seconds: 1));
    yield EnhancementJob(
      id: predictionId,
      status: 'succeeded',
      outputUrl: resultPath,
      mode: mode,
    );
  }

  @override
  Future<String> downloadResultToCache(String url) async {
    return url;
  }

  Future<String> _applyMockEffect(
      String inputPath, EnhancementMode mode) async {
    final bytes = await File(inputPath).readAsBytes();
    var image = img.decodeImage(bytes);
    if (image == null) return inputPath;

    const sharpenKernel = [0, -1, 0, -1, 5, -1, 0, -1, 0];

    switch (mode) {
      case EnhancementMode.enhance:
        // Upscale 2x, sharpen, boost contrast
        image = img.copyResize(image,
            width: image.width * 2,
            height: image.height * 2,
            interpolation: img.Interpolation.cubic);
        image = img.adjustColor(image, contrast: 1.2, brightness: 1.05);
        image = img.convolution(image, filter: sharpenKernel);
      case EnhancementMode.restoreFace:
        // Smooth then sharpen for face restoration effect
        image = img.gaussianBlur(image, radius: 1);
        image = img.convolution(image, filter: sharpenKernel);
        image = img.adjustColor(image, contrast: 1.15, brightness: 1.05);
      case EnhancementMode.colorize:
        // Convert to grayscale then apply a warm color tint
        image = img.grayscale(image);
        image = img.colorOffset(image, red: 30, green: 15, blue: -10);
        image = img.adjustColor(image, contrast: 1.1, saturation: 1.3);
      case EnhancementMode.removeWatermark:
        // Simulate watermark removal with slight blur + sharpen
        image = img.gaussianBlur(image, radius: 2);
        image = img.convolution(image, filter: sharpenKernel);
        image = img.adjustColor(image, contrast: 1.1);
      case EnhancementMode.removeBackground:
        // Simulate bg removal: keep center, make edges transparent
        final w = image.width;
        final h = image.height;
        final result = img.Image(width: w, height: h, numChannels: 4);
        for (int y = 0; y < h; y++) {
          for (int x = 0; x < w; x++) {
            final pixel = image.getPixel(x, y);
            // Simple edge detection: fade edges to transparent
            final dx = (x - w / 2).abs() / (w / 2);
            final dy = (y - h / 2).abs() / (h / 2);
            final dist = (dx * dx + dy * dy).clamp(0.0, 1.0);
            final alpha = dist > 0.7 ? ((1.0 - dist) / 0.3 * 255).toInt() : 255;
            result.setPixelRgba(x, y, pixel.r.toInt(), pixel.g.toInt(),
                pixel.b.toInt(), alpha.clamp(0, 255));
          }
        }
        image = result;
    }

    // Add a small watermark label
    img.drawString(image, 'AI Enhanced (Mock)',
        font: img.arial14,
        x: image.width - 160,
        y: image.height - 24,
        color: img.ColorRgba8(255, 255, 255, 180));

    final ext = mode == EnhancementMode.removeBackground ? 'png' : 'jpg';
    final encoded = mode == EnhancementMode.removeBackground
        ? img.encodePng(image)
        : img.encodeJpg(image, quality: 92);

    return FileUtils.saveBytesToCache(encoded, extension: ext);
  }
}
