import 'package:photo_revive_ai/features/enhance/data/models/enhancement_response.dart';
import 'package:photo_revive_ai/features/enhance/domain/entities/enhancement_job.dart';
import 'package:photo_revive_ai/features/history/data/models/history_item.dart';

class TestData {
  static const successJson = {
    'id': 'test-123',
    'status': 'succeeded',
    'output': 'https://example.com/result.jpg',
    'error': null,
  };

  static const processingJson = {
    'id': 'test-123',
    'status': 'processing',
    'output': null,
    'error': null,
  };

  static const failedJson = {
    'id': 'test-123',
    'status': 'failed',
    'output': null,
    'error': 'Model failed',
  };

  static final successResponse = EnhancementResponse.fromJson(successJson);
  static final processingResponse = EnhancementResponse.fromJson(processingJson);
  static final failedResponse = EnhancementResponse.fromJson(failedJson);

  static const successJob = EnhancementJob(
    id: 'test-123',
    status: 'succeeded',
    outputUrl: 'https://example.com/result.jpg',
    mode: EnhancementMode.enhance,
  );

  static final historyItem = HistoryItem(
    id: 'hist-1',
    originalPath: '/path/original.jpg',
    resultPath: '/path/result.jpg',
    mode: 'enhance',
    createdAt: DateTime(2024, 1, 1),
  );
}
