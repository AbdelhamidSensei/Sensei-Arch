import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_revive_ai/features/enhance/domain/entities/enhancement_job.dart';
import 'package:photo_revive_ai/features/enhance/domain/usecases/poll_status_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockEnhancementRepo mockRepo;
  late PollStatusUseCase useCase;

  setUpAll(() {
    registerFallbackValue(EnhancementMode.enhance);
  });

  setUp(() {
    mockRepo = MockEnhancementRepo();
    useCase = PollStatusUseCase(mockRepo);
  });

  test('emits intermediate statuses and terminates on succeeded', () async {
    when(() => mockRepo.pollStatus(any(), any())).thenAnswer((_) {
      return Stream.fromIterable([
        const EnhancementJob(
            id: '1', status: 'processing', mode: EnhancementMode.enhance),
        const EnhancementJob(
            id: '1',
            status: 'succeeded',
            outputUrl: 'url',
            mode: EnhancementMode.enhance),
      ]);
    });

    final events =
        await useCase('1', EnhancementMode.enhance).toList();

    expect(events.length, 2);
    expect(events[0].status, 'processing');
    expect(events[1].status, 'succeeded');
    expect(events[1].isTerminal, true);
  });
}
