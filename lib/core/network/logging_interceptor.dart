// ═══════════════════════════════════════════════════════════════════
// FILE:     logging_interceptor.dart
// LAYER:    core/network
// PURPOSE:  A Dio interceptor that logs HTTP request/response details
//           through our AppLogger (never raw print).
//
// PLAIN ENGLISH:
//   Every time the app talks to the internet, this interceptor writes
//   a log line: what URL was called, how long it took, and what status
//   code came back. In release builds it NEVER logs request/response
//   bodies (they might contain passwords or personal data).
//
// WHO CREATES ME:
//   Riverpod via core_providers.dart.
//
// WHO USES ME:
//   Dio calls me automatically for every request/response/error.
//
// WHAT I TALK TO:
//   AppLogger only.
// ═══════════════════════════════════════════════════════════════════

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:sensei/core/logger/app_logger.dart';

/// Logs HTTP traffic through [AppLogger] with duration tracking.
///
/// PLAIN ENGLISH: the "flight recorder" for network calls. Helps you
/// see in the console exactly what's being sent and received.
///
/// Called by: Dio (automatically).
/// Calls: [AppLogger].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  /// We store the request start time so we can compute duration on response.
  final Map<RequestOptions, DateTime> _requestTimestamps = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestTimestamps[options] = DateTime.now();
    _logger.d(
      '→ ${options.method} ${options.uri}',
      className: 'LoggingInterceptor',
    );

    // In debug mode only, log headers and request body.
    if (!kReleaseMode) {
      _logger.v('  Headers: ${options.headers}',
          className: 'LoggingInterceptor');
      if (options.data != null) {
        try {
          final jsonStr = jsonEncode(options.data);
          _logger.longD('  Request body (JSON): $jsonStr',
              className: 'LoggingInterceptor');
        } catch (_) {
          _logger.longD('  Request body (raw): ${options.data}',
              className: 'LoggingInterceptor');
        }
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = _calculateDuration(response.requestOptions);
    _logger.d(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri} (${duration}ms)',
      className: 'LoggingInterceptor',
    );

    if (!kReleaseMode) {
      try {
        final jsonStr = jsonEncode(response.data);
        _logger.longD('  Response body (JSON): $jsonStr',
            className: 'LoggingInterceptor');
      } catch (_) {
        _logger.longD('  Response body (raw): ${response.data}',
            className: 'LoggingInterceptor');
      }
    }

    _requestTimestamps.remove(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final duration = _calculateDuration(err.requestOptions);
    _logger.e(
      '✗ ${err.type.name} ${err.requestOptions.method} '
      '${err.requestOptions.uri} (${duration}ms)',
      className: 'LoggingInterceptor',
      error: err,
    );

    if (!kReleaseMode && err.response?.data != null) {
      try {
        final jsonStr = jsonEncode(err.response?.data);
        _logger.longD('  Error response body (JSON): $jsonStr',
            className: 'LoggingInterceptor');
      } catch (_) {
        _logger.longD('  Error response body (raw): ${err.response?.data}',
            className: 'LoggingInterceptor');
      }
    }

    _requestTimestamps.remove(err.requestOptions);
    handler.next(err);
  }

  /// Computes milliseconds since the request was sent.
  int _calculateDuration(RequestOptions options) {
    final startTime = _requestTimestamps[options];
    if (startTime == null) return -1;
    return DateTime.now().difference(startTime).inMilliseconds;
  }
}
