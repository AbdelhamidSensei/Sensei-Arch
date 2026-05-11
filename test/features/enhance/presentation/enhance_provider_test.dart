import 'package:flutter_test/flutter_test.dart';
import 'package:photo_revive_ai/features/enhance/data/repositories/enhancement_repository_impl.dart';
import 'package:photo_revive_ai/features/enhance/domain/entities/enhancement_job.dart';
import 'package:photo_revive_ai/features/enhance/presentation/providers/enhance_provider.dart';

void main() {
  late EnhanceNotifier notifier;

  setUp(() {
    notifier = EnhanceNotifier(MockEnhancementRepository());
  });

  test('initial state has default values', () {
    expect(notifier.state.imagePath, isNull);
    expect(notifier.state.mode, EnhancementMode.enhance);
    expect(notifier.state.isProcessing, false);
  });

  test('setImage updates imagePath', () {
    notifier.setImage('/test.jpg');
    expect(notifier.state.imagePath, '/test.jpg');
  });

  test('setMode updates mode', () {
    notifier.setMode(EnhancementMode.restoreFace);
    expect(notifier.state.mode, EnhancementMode.restoreFace);
  });

  test('reset clears state', () {
    notifier.setImage('/test.jpg');
    notifier.setMode(EnhancementMode.colorize);
    notifier.reset();

    expect(notifier.state.imagePath, isNull);
    expect(notifier.state.mode, EnhancementMode.enhance);
  });
}
